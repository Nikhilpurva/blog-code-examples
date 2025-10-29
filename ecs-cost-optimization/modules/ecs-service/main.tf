resource "aws_lb_target_group" "application-tg" {

  name = var.target_group_name
  # Note that the port 80 specified below is simply the default port for the Target Group. When a Docker container
  # launches, the actual port will be chosen dynamically, so the value specified below is arbitrary.
  port                          = 80
  protocol                      = "HTTP"
  vpc_id                        = var.vpc_id
  target_type                   = var.target_type
  load_balancing_algorithm_type = var.routing_algorithm

  stickiness {
    enabled         = var.enable_sticky_sessions
    type            = "lb_cookie"
    cookie_duration = var.sticky_sessions_cookie_duration # Stickiness duration
  }

  health_check {
    interval            = "30"
    port                = "traffic-port"
    healthy_threshold   = "3"
    unhealthy_threshold = "2"
    protocol            = "HTTP"
    timeout             = var.health_check_timeout
    path                = var.health_check_path
    matcher             = var.http_code
  }
}

resource "aws_ecs_service" "application-service" {

  name                              = var.service_name
  cluster                           = var.cluster_id
  task_definition                   = var.task_definition_arn
  desired_count                     = var.desired_ecs_task
  enable_execute_command            = true
  health_check_grace_period_seconds = 10

  capacity_provider_strategy {
    capacity_provider = var.capacity_provider_name
    weight            = var.on_demand_capacity_weight
    base              = var.on_demand_capacity_base
  }

  capacity_provider_strategy {
    capacity_provider = "capacity-${var.cluster_name}-spot"
    weight            = var.spot_capacity_weight
    base              = var.spot_capacity_base
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "cpu"
  }

  deployment_controller {
    type = "ECS"
  }

  dynamic "network_configuration" {
    for_each = var.network_mode == "awsvpc" ? [1] : []
    content {
      subnets         = var.network_mode == "awsvpc" ? var.subnet_ids : null
      security_groups = var.network_mode == "awsvpc" ? var.ecs_security_group_ids : null
    }
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.application-tg.arn
    container_name   = var.application
    container_port   = var.container_port
  }

  propagate_tags = "SERVICE"

  lifecycle {
    ignore_changes = [desired_count]
  }
}

# Create an App AutoScaling Target that allows us to add AutoScaling Policies to our ECS Service
resource "aws_appautoscaling_target" "appautoscaling_target" {

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  resource_id = "service/${var.cluster_name}/${aws_ecs_service.application-service.name}"

  min_capacity = var.min_ecs_task
  max_capacity = var.max_ecs_task

  depends_on = [
    aws_ecs_service.application-service
  ]
}

resource "aws_appautoscaling_policy" "service-high-cpu-scaling" {

  name        = var.scaling_policy_name_cpu
  resource_id = "service/${var.cluster_name}/${aws_ecs_service.application-service.name}"
  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.scaling_policy_cpu_target_value
    disable_scale_in   = false
    scale_in_cooldown  = 300
    scale_out_cooldown = 30
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    aws_ecs_service.application-service,
    aws_appautoscaling_target.appautoscaling_target
  ]
}

resource "aws_appautoscaling_policy" "service-high-memory-scaling" {
  count = var.enable_memory_scaling ? 1 : 0

  name        = var.scaling_policy_name_mem
  resource_id = "service/${var.cluster_name}/${aws_ecs_service.application-service.name}"
  policy_type = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = var.scaling_policy_memory_target_value
    disable_scale_in   = false
    scale_in_cooldown  = 300
    scale_out_cooldown = 30
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }

  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"

  depends_on = [
    aws_ecs_service.application-service,
    aws_appautoscaling_target.appautoscaling_target
  ]
}

resource "aws_security_group" "lb_sg" {
  vpc_id = var.vpc_id
  name   = var.lb_security_group_name
}

resource "aws_vpc_security_group_egress_rule" "lb_sg_all" {
  security_group_id = aws_security_group.lb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = -1
  ip_protocol = "-1"
  to_port     = -1
  description = "Allow all traffic"
}

resource "aws_vpc_security_group_ingress_rule" "lb_sg_https" {
  count             = length(var.cidr_blocks)
  security_group_id = aws_security_group.lb_sg.id

  cidr_ipv4   = var.cidr_blocks[count.index]
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443
  description = var.cidr_block_descriptions[count.index]
}

resource "aws_lb" "service-lb" {

  name               = var.lb_name
  internal           = var.lb_internal
  load_balancer_type = "application"
  security_groups    = [aws_security_group.lb_sg.id]
  subnets            = var.public_subnet
  idle_timeout       = var.idle_timeout
}

resource "aws_lb_listener" "http_listener" {

  load_balancer_arn = aws_lb.service-lb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"
    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener" "https_listener" {

  load_balancer_arn = aws_lb.service-lb.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.certificate_arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.application-tg.arn
  }
}
