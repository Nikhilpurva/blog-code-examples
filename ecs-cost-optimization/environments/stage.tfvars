service_linked_role         = "arn:aws:iam::<account_id>:role/aws-service-role/autoscaling.amazonaws.com/AWSServiceRoleForAutoScaling"
on_demand_instance_type     = "t4g.small"
container_image             = ""
min_ecs_task                = 1
max_ecs_task                = 4
on_demand_desired_capacity  = 0 # on-demand capacity zero
on_demand_min_size          = 0 # on-demand capacity zero
cidr_blocks                 = []
cidr_block_descriptions     = []
acm_cert_arn                = ""

spot_instance_types       = ["t4g.micro", "t4g.small", "c6g.large", "c7g.large"]
on_demand_capacity_base   = 0
on_demand_capacity_weight = 0
spot_capacity_base        = 0
spot_capacity_weight      = 1 #all ECS tasks will run on spot only
