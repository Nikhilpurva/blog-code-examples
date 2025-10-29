locals {
  user_data = templatefile(
    "${path.module}/user-data.sh",
    {
      cluster_name = var.cluster_name
    },
  )
  capacity_provider_count = var.capacity_provider_count
  asg_tags = merge(
    data.aws_default_tags.current.tags,
    var.tags,
    { "Name" = coalesce(var.instance_name, var.name) },
    var.autoscaling_group_tags,
  )
  launch_template_version = var.launch_template_version == null ? aws_launch_template.spot_lt.latest_version : var.launch_template_version
}

data "aws_default_tags" "current" {}

#Fetch the subnet details
data "aws_subnets" "private" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
  tags = {
    Name = "*-priv*"
  }
}

#Fetch Amazon Linux 2023 ECS Optimized AMI
data "aws_ami" "al2023_ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-ecs-hvm-2023*"]
  }

  filter {
    name   = "architecture"
    values = var.architecture
  }
}

#Cloudwatch log group
resource "aws_cloudwatch_log_group" "cluster-logs" {
  name              = "${var.cluster_name}-cluster-logs"
  retention_in_days = var.cluster_log_retention_period
}

# Create the CloudWatch Logs stream
resource "aws_cloudwatch_log_stream" "cluster-logs-stream" {
  name           = "${var.cluster_name}-cluster-stream"
  log_group_name = aws_cloudwatch_log_group.cluster-logs.name
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS CLUSTER INSTANCE SECURITY GROUP
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_security_group" "ecs" {
  name        = "${var.cluster_name}-sg"
  description = "For EC2 Instances in the ECS Cluster."
  vpc_id      = var.vpc_id
}

#Allow all outbound traffic from the ECS Cluster
resource "aws_security_group_rule" "allow_outbound_all" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = aws_security_group.ecs.id
}
resource "aws_iam_role" "ecs" {
  name               = "${var.cluster_name}-cluster-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_role.json

  # IAM objects take time to propagate. This leads to subtle eventual consistency bugs where the ECS cluster cannot be
  # created because the IAM role does not exist. We add a 15 second wait here to give the IAM role a chance to propagate
  # within AWS.
  provisioner "local-exec" {
    command = "echo 'Sleeping for 15 seconds to wait for IAM role to be created'; sleep 15"
  }
}

data "aws_iam_policy_document" "ecs_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# To assign an IAM Role to an EC2 instance, we need to create an "IAM Instance Profile".
resource "aws_iam_instance_profile" "ecs" {
  name = "${var.cluster_name}-ecs"
  role = aws_iam_role.ecs.name
}

# Adding set of permission that let user login/ssh into ec2 launched by asg using ssm.
resource "aws_iam_role_policy_attachment" "ecs_ssm" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

resource "aws_iam_role_policy_attachment" "cwagent" {
  role       = aws_iam_role.ecs.name
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

data "aws_iam_policy_document" "kms_policy" {
  statement {
    effect    = "Allow"
    actions   = ["kms:Decrypt"]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "kms_inline_policy" {
  name   = "kms-decrypt-policy"
  role   = aws_iam_role.ecs.id
  policy = data.aws_iam_policy_document.kms_policy.json
}

# IAM policy we add to our EC2 Instance Role that allows an ECS Agent running on the EC2 Instance to communicate with
# an ECS cluster.

resource "aws_iam_role_policy_attachment" "ecs" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  role       = aws_iam_role.ecs.id
}

# IAM policy we add to our EC2 Instance Role that allows ECS Instances to pull all containers from Amazon EC2 Container
# Registry.
resource "aws_iam_role_policy" "ecr" {
  name   = "${var.cluster_name}-ecr-permission"
  role   = aws_iam_role.ecs.id
  policy = data.aws_iam_policy_document.ecr_permissions.json
}

data "aws_iam_policy_document" "ecr_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:BatchGetImage",
      "ecr:DescribeRepositories",
      "ecr:GetAuthorizationToken",
      "ecr:GetDownloadUrlForLayer",
      "ecr:GetRepositoryPolicy",
      "ecr:ListImages"
    ]

    resources = ["*"]
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS CLUSTER AUTO SCALING GROUP (ASG)
# ---------------------------------------------------------------------------------------------------------------------

module "cluster-asg" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "6.10.0"

  name                            = "${var.cluster_name}-ecs-cluster-asg"
  use_name_prefix                 = false
  vpc_zone_identifier             = data.aws_subnets.private.ids
  min_size                        = var.on_demand_min_size
  max_size                        = var.on_demand_max_size
  desired_capacity                = var.on_demand_desired_capacity
  ignore_desired_capacity_changes = var.ignore_desired_capacity_changes
  service_linked_role_arn         = var.service_linked_role
  instance_refresh = {
    strategy = "Rolling"
    preferences = {
      min_healthy_percentage    = 90
      instance_warmup           = 10
      ScaleInProtectedInstances = "Refresh"
    }
    triggers = ["launch_template"]
  }

  #LaunchTemplate
  launch_template_name        = "${var.cluster_name}-ecs-cluster-lt"
  launch_template_description = "${var.cluster_name} ECS cluster launch template"
  update_default_version      = true
  image_id                    = data.aws_ami.al2023_ecs_optimized.id
  instance_type               = var.on_demand_instance_type
  user_data                   = base64encode(local.user_data)
  enable_monitoring           = true
  enabled_metrics             = var.enabled_metrics
  security_groups             = [aws_security_group.ecs.id]
  termination_policies        = ["OldestInstance", "NewestInstance"]
  iam_instance_profile_arn    = aws_iam_instance_profile.ecs.arn
  tag_specifications          = var.tag_specifications
}

resource "aws_launch_template" "spot_lt" {
  name_prefix   = "${var.cluster_name}-ecs-cluster-spot-lt"
  image_id      = data.aws_ami.al2023_ecs_optimized.id
  instance_type = var.on_demand_instance_type # default, can be overridden in ASG

  iam_instance_profile {
    name = aws_iam_instance_profile.ecs.name
  }

  vpc_security_group_ids = [aws_security_group.ecs.id]

  # User data: join ECS cluster automatically
  user_data = base64encode(local.user_data)
  dynamic "tag_specifications" {
    for_each = var.tag_specifications
    content {
      resource_type = tag_specifications.value.resource_type
      tags          = merge(var.tags, tag_specifications.value.tags)
    }
  }
}

resource "aws_autoscaling_group" "ecs_spot_asg" {
  name                = "${var.cluster_name}-ecs-cluster-spot-asg"
  vpc_zone_identifier = data.aws_subnets.private.ids
  health_check_type   = "EC2"
  min_size            = var.spot_min_size
  max_size            = var.spot_max_size
  desired_capacity    = var.spot_min_size

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.spot_lt.id
        version            = local.launch_template_version
      }

      dynamic "override" {
        for_each = var.spot_instance_types
        content {
          instance_type = override.value
        }
      }
    }
    instances_distribution {
      on_demand_percentage_above_base_capacity = 0 # 0% On-Demand, 100% Spot
      spot_allocation_strategy                 = var.spot_allocation_strategy
    }
  }
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage       = 90
      instance_warmup              = 10
      scale_in_protected_instances = "Refresh"
    }
    triggers = ["launch_template"]
  }

  enabled_metrics = var.enabled_metrics

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }

  dynamic "tag" {
    for_each = local.asg_tags
    content {
      key                 = tag.key
      value               = tag.value
      propagate_at_launch = true
    }
  }

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [desired_capacity]
  }
}

# Capacity providers for the cluster to enable autoscaling.
resource "aws_ecs_capacity_provider" "capacity_provider" {
  name = "capacity-${var.cluster_name}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = module.cluster-asg.autoscaling_group_arn
    managed_termination_protection = var.managed_termination_protection_capacity_provider

    managed_scaling {
      maximum_scaling_step_size = var.maximum_scaling_step_size
      minimum_scaling_step_size = var.minimum_scaling_step_size
      status                    = "ENABLED"
      target_capacity           = var.target_capacity
    }
  }
}

resource "aws_ecs_capacity_provider" "spot" {
  name = "capacity-${var.cluster_name}-spot"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.ecs_spot_asg.arn
    managed_termination_protection = var.managed_termination_protection_capacity_provider

    managed_scaling {
      maximum_scaling_step_size = var.spot_max_size
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 100
    }
  }
}

resource "aws_ecs_cluster_capacity_providers" "capacity_providers" {
  cluster_name       = aws_ecs_cluster.ecs_cluster.name
  capacity_providers = [aws_ecs_capacity_provider.capacity_provider.name, aws_ecs_capacity_provider.spot.name]

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.capacity_provider.name
    base              = var.on_demand_capacity_base
    weight            = var.on_demand_capacity_weight
  }

  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.spot.name
    base              = var.spot_capacity_base
    weight            = var.spot_capacity_weight
  }
}

# ---------------------------------------------------------------------------------------------------------------------
# CREATE THE ECS CLUSTER
# ---------------------------------------------------------------------------------------------------------------------

resource "aws_ecs_cluster" "ecs_cluster" {
  name = var.cluster_name

  setting {
    name  = "containerInsights"
    value = var.containerInsights
  }
  configuration {
    execute_command_configuration {
      logging = "OVERRIDE"
      log_configuration {
        cloud_watch_log_group_name = aws_cloudwatch_log_group.cluster-logs.name
      }
    }
  }
}
