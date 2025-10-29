<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_ecs-cluster"></a> [ecs-cluster](#module\_ecs-cluster) | ./modules/ecs-cluster | n/a |
| <a name="module_ecs-service"></a> [ecs-service](#module\_ecs-service) | ./modules/ecs-service | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_cloudwatch_log_group.application-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.application-stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ecs_task_definition.ecs-task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.SSMPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_task_role_attachment](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_security_group.ecs-task-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |
| [aws_subnets.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acm_cert_arn"></a> [acm\_cert\_arn](#input\_acm\_cert\_arn) | ACM certificate to be used for the distribution. All TI  domains can use this same cert as it has subject alternative names (SAN) for all TI domains | `string` | `"value"` | no |
| <a name="input_application"></a> [application](#input\_application) | Application name. | `string` | `""` | no |
| <a name="input_cidr_block_descriptions"></a> [cidr\_block\_descriptions](#input\_cidr\_block\_descriptions) | Enter the CIDR block description(s) | `list(string)` | <pre>[<br/>  "Allow all traffic"<br/>]</pre> | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | Enter the CIDR block to allow 80 and 443 for ALB | `list(any)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_container_image"></a> [container\_image](#input\_container\_image) | Container image | `string` | n/a | yes |
| <a name="input_container_image_version"></a> [container\_image\_version](#input\_container\_image\_version) | Container image version | `string` | `"latest"` | no |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container port | `number` | `80` | no |
| <a name="input_cpu"></a> [cpu](#input\_cpu) | CPU assigned to a task | `number` | `512` | no |
| <a name="input_desired_ec2_capacity"></a> [desired\_ec2\_capacity](#input\_desired\_ec2\_capacity) | Number of desired EC2 in the ASG | `string` | `"1"` | no |
| <a name="input_desired_ecs_task"></a> [desired\_ecs\_task](#input\_desired\_ecs\_task) | Number of desired ECS task in the service | `number` | `1` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name. | `string` | n/a | yes |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | n/a | `string` | `"/healthcheck"` | no |
| <a name="input_max_ecs_task"></a> [max\_ecs\_task](#input\_max\_ecs\_task) | Number of maximum tasks to run in the service | `number` | n/a | yes |
| <a name="input_memory"></a> [memory](#input\_memory) | Memmory assigned to a task | `number` | `512` | no |
| <a name="input_min_ecs_task"></a> [min\_ecs\_task](#input\_min\_ecs\_task) | Number of minimum tasks to run in the service | `string` | n/a | yes |
| <a name="input_on_demand_capacity_base"></a> [on\_demand\_capacity\_base](#input\_on\_demand\_capacity\_base) | The number of tasks, at a minimum, to run on the on-demand capacity provider. | `number` | `"0"` | no |
| <a name="input_on_demand_capacity_weight"></a> [on\_demand\_capacity\_weight](#input\_on\_demand\_capacity\_weight) | The relative percentage of the total number of launched tasks that should use the on-demand capacity provider. | `number` | `"100"` | no |
| <a name="input_on_demand_desired_capacity"></a> [on\_demand\_desired\_capacity](#input\_on\_demand\_desired\_capacity) | Number of desired EC2 in the ASG | `string` | `"1"` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | Enter the ARM based Instance type | `string` | `"t4g.micro"` | no |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Maximum size of EC2 hosts in ECS Cluster | `number` | `"10"` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Minimum size of EC2 hosts in ECS Cluster | `number` | `"1"` | no |
| <a name="input_profile_name"></a> [profile\_name](#input\_profile\_name) | AWS Profile Name. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | AWS Region. | `string` | n/a | yes |
| <a name="input_service_linked_role"></a> [service\_linked\_role](#input\_service\_linked\_role) | Service Linked Role ARN | `string` | n/a | yes |
| <a name="input_spot_allocation_strategy"></a> [spot\_allocation\_strategy](#input\_spot\_allocation\_strategy) | How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized, capacity-optimized-prioritized, and price-capacity-optimized. | `string` | `"price-capacity-optimized"` | no |
| <a name="input_spot_capacity_base"></a> [spot\_capacity\_base](#input\_spot\_capacity\_base) | The number of tasks, at a minimum, to run on the on-demand capacity provider. | `number` | `"0"` | no |
| <a name="input_spot_capacity_weight"></a> [spot\_capacity\_weight](#input\_spot\_capacity\_weight) | The relative percentage of the total number of launched tasks that should use the on-demand capacity provider. | `number` | `"0"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Enter the desired bumber of spot instance to run in ASG | `number` | `"1"` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | List of instance types to use in the Spot Auto Scaling Group.<br/><br/>💡 The order of instance types matters:<br/>- The first instance type has the highest priority.<br/>- Subsequent types are used as fallbacks in case the preferred type is unavailable.<br/><br/>Example: ["t4g.small", "t4g.medium", "t4g.large"] | `list(string)` | <pre>[<br/>  "t4g.small"<br/>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Enter the max spot instance to run in ASG | `number` | `"5"` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Enter the min spot instance to run in ASG | `number` | `"1"` | no |
| <a name="input_tag"></a> [tag](#input\_tag) | Tag values to attach with all the resources | `string` | `""` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | The ID of the VPC. | `string` | `""` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->