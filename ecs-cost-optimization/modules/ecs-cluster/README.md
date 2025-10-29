<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_cluster-asg"></a> [cluster-asg](#module\_cluster-asg) | terraform-aws-modules/autoscaling/aws | 6.10.0 |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.ecs_spot_asg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_cloudwatch_log_group.cluster-logs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_stream.cluster-logs-stream](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_stream) | resource |
| [aws_ecs_capacity_provider.capacity_provider](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_capacity_provider.spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_capacity_provider) | resource |
| [aws_ecs_cluster.ecs_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_ecs_cluster_capacity_providers.capacity_providers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster_capacity_providers) | resource |
| [aws_iam_instance_profile.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.kms_inline_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.cwagent](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ecs_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_launch_template.spot_lt](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.ecs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.allow_outbound_all](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_ami.al2023_ecs_optimized](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |
| [aws_default_tags.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/default_tags) | data source |
| [aws_iam_policy_document.ecr_permissions](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.ecs_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_subnets.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/subnets) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_application_log_retention_period"></a> [application\_log\_retention\_period](#input\_application\_log\_retention\_period) | Number of the days for retention of the application logs | `number` | `30` | no |
| <a name="input_architecture"></a> [architecture](#input\_architecture) | AMI architecture valid values are arm64 and x86\_64 | `list(string)` | <pre>[<br/>  "arm64"<br/>]</pre> | no |
| <a name="input_autoscaling_group_tags"></a> [autoscaling\_group\_tags](#input\_autoscaling\_group\_tags) | A map of additional tags to add to the autoscaling group | `map(string)` | `{}` | no |
| <a name="input_capacity_provider_count"></a> [capacity\_provider\_count](#input\_capacity\_provider\_count) | Number of capacity | `string` | `1` | no |
| <a name="input_cluster_log_retention_period"></a> [cluster\_log\_retention\_period](#input\_cluster\_log\_retention\_period) | Number of the days for retention of the cluster logs | `number` | `30` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the cluster | `string` | n/a | yes |
| <a name="input_containerInsights"></a> [containerInsights](#input\_containerInsights) | Enable to Disable the container insight | `string` | `"enabled"` | no |
| <a name="input_enabled_metrics"></a> [enabled\_metrics](#input\_enabled\_metrics) | List of metrics to collect | `list(string)` | <pre>[<br/>  "GroupDesiredCapacity",<br/>  "GroupInServiceInstances",<br/>  "GroupMaxSize",<br/>  "GroupMinSize",<br/>  "GroupPendingInstances",<br/>  "GroupStandbyInstances",<br/>  "GroupTerminatingInstances",<br/>  "GroupTotalInstances"<br/>]</pre> | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Type of environment like prod/stage/dev | `string` | n/a | yes |
| <a name="input_ignore_desired_capacity_changes"></a> [ignore\_desired\_capacity\_changes](#input\_ignore\_desired\_capacity\_changes) | Determines whether the desired\_capacity value is ignored after initial apply | `bool` | `true` | no |
| <a name="input_instance_name"></a> [instance\_name](#input\_instance\_name) | Name that is propogated to launched EC2 instances via a tag - if not provided, defaults to `var.name` | `string` | `""` | no |
| <a name="input_launch_template_version"></a> [launch\_template\_version](#input\_launch\_template\_version) | Launch template version. Can be version number, `$Latest`, or `$Default` | `string` | `null` | no |
| <a name="input_managed_termination_protection_capacity_provider"></a> [managed\_termination\_protection\_capacity\_provider](#input\_managed\_termination\_protection\_capacity\_provider) | managed\_termination\_protection\_capacity\_provider | `string` | `"DISABLED"` | no |
| <a name="input_maximum_scaling_step_size"></a> [maximum\_scaling\_step\_size](#input\_maximum\_scaling\_step\_size) | Maximum number of step scaling | `number` | `20` | no |
| <a name="input_minimum_scaling_step_size"></a> [minimum\_scaling\_step\_size](#input\_minimum\_scaling\_step\_size) | Minimum number of step scaling | `number` | `1` | no |
| <a name="input_name"></a> [name](#input\_name) | Name used across the resources created | `string` | `"marketplace"` | no |
| <a name="input_on_demand_capacity_base"></a> [on\_demand\_capacity\_base](#input\_on\_demand\_capacity\_base) | The number of tasks, at a minimum, to run on the on-demand capacity provider. | `number` | `"1"` | no |
| <a name="input_on_demand_capacity_weight"></a> [on\_demand\_capacity\_weight](#input\_on\_demand\_capacity\_weight) | The relative percentage of the total number of launched tasks that should use the on-demand capacity provider. | `number` | `"100"` | no |
| <a name="input_on_demand_desired_capacity"></a> [on\_demand\_desired\_capacity](#input\_on\_demand\_desired\_capacity) | Number of desired EC2 in the ASG | `string` | `"1"` | no |
| <a name="input_on_demand_instance_type"></a> [on\_demand\_instance\_type](#input\_on\_demand\_instance\_type) | On-demand Instance type | `string` | n/a | yes |
| <a name="input_on_demand_max_size"></a> [on\_demand\_max\_size](#input\_on\_demand\_max\_size) | Maximum size of EC2 hosts in ECS Cluster | `number` | `"10"` | no |
| <a name="input_on_demand_min_size"></a> [on\_demand\_min\_size](#input\_on\_demand\_min\_size) | Minimum size of EC2 hosts in ECS Cluster | `number` | `"1"` | no |
| <a name="input_region"></a> [region](#input\_region) | Region name | `string` | n/a | yes |
| <a name="input_service_linked_role"></a> [service\_linked\_role](#input\_service\_linked\_role) | Service Linked Role. | `string` | n/a | yes |
| <a name="input_spot_allocation_strategy"></a> [spot\_allocation\_strategy](#input\_spot\_allocation\_strategy) | How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized, capacity-optimized-prioritized, and price-capacity-optimized. | `string` | `"price-capacity-optimized"` | no |
| <a name="input_spot_capacity_base"></a> [spot\_capacity\_base](#input\_spot\_capacity\_base) | The number of tasks, at a minimum, to run on the on-demand capacity provider. | `number` | `"0"` | no |
| <a name="input_spot_capacity_weight"></a> [spot\_capacity\_weight](#input\_spot\_capacity\_weight) | The relative percentage of the total number of launched tasks that should use the on-demand capacity provider. | `number` | `"0"` | no |
| <a name="input_spot_desired_size"></a> [spot\_desired\_size](#input\_spot\_desired\_size) | Enter the desired bumber of spot instance to run in ASG | `number` | `"1"` | no |
| <a name="input_spot_instance_types"></a> [spot\_instance\_types](#input\_spot\_instance\_types) | List of instance types to use in the Spot Auto Scaling Group.<br/><br/>💡 The order of instance types matters:<br/>- The first instance type has the highest priority.<br/>- Subsequent types are used as fallbacks in case the preferred type is unavailable.<br/><br/>Example: ["t4g.small", "t4g.medium", "t4g.large"] | `list(string)` | <pre>[<br/>  "t4g.small"<br/>]</pre> | no |
| <a name="input_spot_max_size"></a> [spot\_max\_size](#input\_spot\_max\_size) | Enter the max spot instance to run in ASG | `number` | `"5"` | no |
| <a name="input_spot_min_size"></a> [spot\_min\_size](#input\_spot\_min\_size) | Enter the min spot instance to run in ASG | `number` | `"1"` | no |
| <a name="input_tag_specifications"></a> [tag\_specifications](#input\_tag\_specifications) | The tags to apply to the resources during launch | `list(any)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to resources | `map(string)` | `{}` | no |
| <a name="input_target_capacity"></a> [target\_capacity](#input\_target\_capacity) | Target Capacity percentage | `number` | `100` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | Enter the VPC id | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_capacity_provider_name"></a> [capacity\_provider\_name](#output\_capacity\_provider\_name) | Name of the Capacity provider |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | The arn for ECS cluster |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | The id for ECS cluster |
| <a name="output_ecs_security_group"></a> [ecs\_security\_group](#output\_ecs\_security\_group) | ECS security group ids |
| <a name="output_on_demand_asg_name"></a> [on\_demand\_asg\_name](#output\_on\_demand\_asg\_name) | Name of the on-demand autoscaling group |
| <a name="output_spot_asg_name"></a> [spot\_asg\_name](#output\_spot\_asg\_name) | Name of the spot autoscaling group |
<!-- END_TF_DOCS -->