<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_appautoscaling_policy.service-high-cpu-scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_policy.service-high-memory-scaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_policy) | resource |
| [aws_appautoscaling_target.appautoscaling_target](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/appautoscaling_target) | resource |
| [aws_ecs_service.application-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_lb.service-lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener.https_listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.application-tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_security_group.lb_sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_vpc_security_group_egress_rule.lb_sg_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.lb_sg_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc_security_group_ingress_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application"></a> [application](#input\_application) | Application name | `string` | n/a | yes |
| <a name="input_capacity_provider_name"></a> [capacity\_provider\_name](#input\_capacity\_provider\_name) | Number of the capacity provider | `string` | n/a | yes |
| <a name="input_certificate_arn"></a> [certificate\_arn](#input\_certificate\_arn) | Certificate ARN | `string` | n/a | yes |
| <a name="input_cidr_block_descriptions"></a> [cidr\_block\_descriptions](#input\_cidr\_block\_descriptions) | Enter the CIDR block description(s) | `list(string)` | <pre>[<br/>  "Allow all traffic"<br/>]</pre> | no |
| <a name="input_cidr_blocks"></a> [cidr\_blocks](#input\_cidr\_blocks) | Enter the CIDR block to allow 80 and 443 for ALB | `list(any)` | <pre>[<br/>  "0.0.0.0/0"<br/>]</pre> | no |
| <a name="input_cluster_id"></a> [cluster\_id](#input\_cluster\_id) | Cluster ID | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the Cluster | `string` | n/a | yes |
| <a name="input_container_port"></a> [container\_port](#input\_container\_port) | Container port number | `number` | n/a | yes |
| <a name="input_desired_ecs_task"></a> [desired\_ecs\_task](#input\_desired\_ecs\_task) | Number of desired tasks to run in the service | `string` | n/a | yes |
| <a name="input_ecs_security_group_ids"></a> [ecs\_security\_group\_ids](#input\_ecs\_security\_group\_ids) | Enter the ecs host security group | `list(string)` | `null` | no |
| <a name="input_enable_memory_scaling"></a> [enable\_memory\_scaling](#input\_enable\_memory\_scaling) | Flag to enable or disable memory-based scaling policy | `bool` | `false` | no |
| <a name="input_enable_sticky_sessions"></a> [enable\_sticky\_sessions](#input\_enable\_sticky\_sessions) | n/a | `bool` | `false` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Type of environment like prod/stage/dev | `string` | n/a | yes |
| <a name="input_health_check_path"></a> [health\_check\_path](#input\_health\_check\_path) | Path of Healthcheck | `string` | `"/"` | no |
| <a name="input_health_check_timeout"></a> [health\_check\_timeout](#input\_health\_check\_timeout) | Healthcheck timeout | `number` | `10` | no |
| <a name="input_http_code"></a> [http\_code](#input\_http\_code) | HTTP code for healthcheck. Matches that used for EC2 | `string` | `"200,302"` | no |
| <a name="input_idle_timeout"></a> [idle\_timeout](#input\_idle\_timeout) | The time in seconds that the connection is allowed to be idle | `number` | `"60"` | no |
| <a name="input_lb_internal"></a> [lb\_internal](#input\_lb\_internal) | Should Loadbalancer be in a private VPC | `bool` | `false` | no |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | Loadbalancer Name | `string` | n/a | yes |
| <a name="input_lb_security_group_name"></a> [lb\_security\_group\_name](#input\_lb\_security\_group\_name) | Loadbalancer Security Group Name | `string` | n/a | yes |
| <a name="input_max_ecs_task"></a> [max\_ecs\_task](#input\_max\_ecs\_task) | Number of maximum tasks to run in the service | `number` | n/a | yes |
| <a name="input_min_ecs_task"></a> [min\_ecs\_task](#input\_min\_ecs\_task) | Number of minimum tasks to run in the service | `string` | n/a | yes |
| <a name="input_network_mode"></a> [network\_mode](#input\_network\_mode) | Enter the network mode | `string` | `"awsvpc"` | no |
| <a name="input_on_demand_capacity_base"></a> [on\_demand\_capacity\_base](#input\_on\_demand\_capacity\_base) | The number of tasks, at a minimum, to run on the on-demand capacity provider. | `number` | `"1"` | no |
| <a name="input_on_demand_capacity_weight"></a> [on\_demand\_capacity\_weight](#input\_on\_demand\_capacity\_weight) | The relative percentage of the total number of launched tasks that should use the on-demand capacity provider. | `number` | `"100"` | no |
| <a name="input_public_subnet"></a> [public\_subnet](#input\_public\_subnet) | Public subnet | `list(any)` | n/a | yes |
| <a name="input_routing_algorithm"></a> [routing\_algorithm](#input\_routing\_algorithm) | Enter the routing algorithm, valid values are: least\_outstanding\_requests, round\_robin | `string` | `"round_robin"` | no |
| <a name="input_scaling_policy_cpu_target_value"></a> [scaling\_policy\_cpu\_target\_value](#input\_scaling\_policy\_cpu\_target\_value) | Target Value for CPU autoscaling policy | `number` | `70` | no |
| <a name="input_scaling_policy_memory_target_value"></a> [scaling\_policy\_memory\_target\_value](#input\_scaling\_policy\_memory\_target\_value) | Target Value for Memory autoscaling policy | `number` | `70` | no |
| <a name="input_scaling_policy_name_cpu"></a> [scaling\_policy\_name\_cpu](#input\_scaling\_policy\_name\_cpu) | Scaling Policy Name for cpu autoscaling policy | `string` | `""` | no |
| <a name="input_scaling_policy_name_mem"></a> [scaling\_policy\_name\_mem](#input\_scaling\_policy\_name\_mem) | Scaling Policy Name for memory autoscaling policy | `string` | `""` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the Service | `string` | n/a | yes |
| <a name="input_spot_capacity_base"></a> [spot\_capacity\_base](#input\_spot\_capacity\_base) | The number of tasks, at a minimum, to run on the on-demand capacity provider. | `number` | `"0"` | no |
| <a name="input_spot_capacity_weight"></a> [spot\_capacity\_weight](#input\_spot\_capacity\_weight) | The relative percentage of the total number of launched tasks that should use the on-demand capacity provider. | `number` | `"0"` | no |
| <a name="input_sticky_sessions_cookie_duration"></a> [sticky\_sessions\_cookie\_duration](#input\_sticky\_sessions\_cookie\_duration) | n/a | `number` | `"86400"` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Enter the subnet ids | `list(string)` | `null` | no |
| <a name="input_target_group_name"></a> [target\_group\_name](#input\_target\_group\_name) | Name of the Target Group | `string` | n/a | yes |
| <a name="input_target_type"></a> [target\_type](#input\_target\_type) | Target group target type valid values: instance, ip | `string` | `"ip"` | no |
| <a name="input_task_definition_arn"></a> [task\_definition\_arn](#input\_task\_definition\_arn) | ARN of task definition | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_cluster_alb_zone_id"></a> [cluster\_alb\_zone\_id](#output\_cluster\_alb\_zone\_id) | Canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record) |
| <a name="output_cluster_dns_name"></a> [cluster\_dns\_name](#output\_cluster\_dns\_name) | DNS name of the load balancer |
| <a name="output_lb_security_group"></a> [lb\_security\_group](#output\_lb\_security\_group) | LB security group ids |
<!-- END_TF_DOCS -->