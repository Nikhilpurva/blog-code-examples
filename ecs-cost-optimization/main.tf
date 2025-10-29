locals {
  cluster_name = "${var.application}-${var.environment}"
}

data "aws_caller_identity" "current" {}

data "aws_subnets" "public" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    Name = "*-pub*"
  }
}

data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    Name = "*-priv*"
  }
}

module "ecs-cluster" {
  source                     = "./modules/ecs-cluster"
  cluster_name               = local.cluster_name
  vpc_id                     = var.vpc_id
  service_linked_role        = var.service_linked_role
  region                     = var.region
  environment                = var.environment
  on_demand_min_size         = var.on_demand_min_size
  on_demand_max_size         = var.on_demand_max_size
  on_demand_desired_capacity = var.on_demand_desired_capacity
  on_demand_instance_type    = var.on_demand_instance_type
  on_demand_capacity_base    = var.on_demand_capacity_base
  on_demand_capacity_weight  = var.on_demand_capacity_weight
  spot_instance_types        = var.spot_instance_types
  spot_min_size              = var.spot_min_size
  spot_max_size              = var.spot_max_size
  spot_desired_size          = var.spot_desired_size
  spot_capacity_base         = var.spot_capacity_base
  spot_capacity_weight       = var.spot_capacity_weight
  spot_allocation_strategy   = var.spot_allocation_strategy


  tag_specifications = [
    {
      resource_type = "volume"
      tags          = module.tag_generator.tags
    },
    {
      resource_type = "network-interface"
      tags          = module.tag_generator.tags
    }
  ]
}

resource "aws_iam_role" "ecs_task_role" {
  name = "ecs-ecs-task-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = { Service = "ecs-tasks.amazonaws.com" }
        Action    = "sts:AssumeRole"
      }
    ]
  })
}

# Attach an IAM policy to the ECS task role
resource "aws_iam_role_policy_attachment" "ecs_task_role_attachment" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "SSMPolicy" {
  role       = aws_iam_role.ecs_task_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_cloudwatch_log_group" "application-logs" {
  name              = "${local.cluster_name}-logs"
  retention_in_days = 14
}

# Create the CloudWatch Logs stream
resource "aws_cloudwatch_log_stream" "application-stream" {
  name           = "${local.cluster_name}-stream"
  log_group_name = aws_cloudwatch_log_group.application-logs.name
  depends_on     = [aws_cloudwatch_log_group.application-logs]
}

resource "aws_ecs_task_definition" "ecs-task" {
  family                   = "${local.cluster_name}-td"
  container_definitions    = local.ecs_task_container_definitions
  requires_compatibilities = ["EC2"]
  task_role_arn            = aws_iam_role.ecs_task_role.arn
  execution_role_arn       = aws_iam_role.ecs_task_role.arn
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode             = "awsvpc"
}

locals {
  ecs_task_container_definitions = templatefile(
    "${path.module}/containers/container-definitions.json",
    {
      container_name = var.application
      image          = var.container_image
      version        = var.container_image_version
      cpu            = var.cpu
      memory         = var.memory
      container_port = var.container_port
      log_group      = aws_cloudwatch_log_group.application-logs.name
      region         = var.region
      log_stream     = aws_cloudwatch_log_stream.application-stream.name
      mount_points   = local.json_no_mount_points
      account_id     = data.aws_caller_identity.current.account_id
    },
  )
  json_no_mount_points = jsonencode([])
}

resource "aws_security_group" "ecs-task-sg" {
  name        = "${local.cluster_name}-task-sg"
  description = "ECS task security group allow all traffic from lb"
  vpc_id      = var.vpc_id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description     = "Allow all port from ALB"
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = [module.ecs-service.lb_security_group]
  }
}

module "ecs-service" {

  source                    = "./modules/ecs-service"
  cluster_name              = local.cluster_name
  vpc_id                    = var.vpc_id
  service_name              = "${local.cluster_name}-service"
  cluster_id                = module.ecs-cluster.cluster_id
  task_definition_arn       = aws_ecs_task_definition.ecs-task.arn
  desired_ecs_task          = var.desired_ecs_task
  min_ecs_task              = var.min_ecs_task
  max_ecs_task              = var.max_ecs_task
  capacity_provider_name    = module.ecs-cluster.capacity_provider_name
  application               = var.application
  container_port            = var.container_port
  public_subnet             = data.aws_subnets.public.ids
  certificate_arn           = module.ecs-acm.acm_certificate_arn
  lb_name                   = "${local.cluster_name}-lb-ecs"
  lb_security_group_name    = "${local.cluster_name}-alb-sg"
  scaling_policy_name_cpu   = "${local.cluster_name}-service-high-cpu-target-tracking"
  target_group_name         = "${local.cluster_name}-ecs-tg"
  health_check_path         = var.health_check_path
  subnet_ids                = data.aws_subnets.private.ids
  ecs_security_group_ids    = [aws_security_group.ecs-task-sg.id]
  cidr_blocks               = var.cidr_blocks
  cidr_block_descriptions   = var.cidr_block_descriptions
  environment               = var.environment
  on_demand_capacity_base   = var.on_demand_capacity_base
  on_demand_capacity_weight = var.on_demand_capacity_weight
  spot_capacity_base        = var.spot_capacity_base
  spot_capacity_weight      = var.spot_capacity_weight
}
