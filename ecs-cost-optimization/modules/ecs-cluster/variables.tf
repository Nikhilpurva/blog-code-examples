variable "capacity_provider_count" {
  type        = string
  description = "Number of capacity"
  default     = 1
}

variable "managed_termination_protection_capacity_provider" {
  type        = string
  description = "managed_termination_protection_capacity_provider"
  default     = "DISABLED"
}

variable "cluster_name" {
  type        = string
  description = "Name of the cluster"
}

variable "vpc_id" {
  type        = string
  description = "Enter the VPC id"
}

variable "region" {
  type        = string
  description = "Region name"
}

variable "on_demand_instance_type" {
  type        = string
  description = "On-demand Instance type"
}

variable "service_linked_role" {
  description = "Service Linked Role."
  type        = string
}

variable "environment" {
  type        = string
  description = "Type of environment like prod/stage/dev"
}

variable "on_demand_min_size" {
  type        = number
  description = "Minimum size of EC2 hosts in ECS Cluster"
  default     = "1"
}

variable "on_demand_max_size" {
  type        = number
  description = "Maximum size of EC2 hosts in ECS Cluster"
  default     = "10"
}

variable "on_demand_desired_capacity" {
  type        = string
  description = "Number of desired EC2 in the ASG"
  default     = "1"
}

variable "cluster_log_retention_period" {
  type        = number
  description = "Number of the days for retention of the cluster logs"
  default     = 30
}

variable "application_log_retention_period" {
  type        = number
  description = "Number of the days for retention of the application logs"
  default     = 30
}

variable "minimum_scaling_step_size" {
  type        = number
  description = "Minimum number of step scaling"
  default     = 1
}

variable "maximum_scaling_step_size" {
  type        = number
  description = "Maximum number of step scaling"
  default     = 20
}

variable "target_capacity" {
  type        = number
  description = "Target Capacity percentage"
  default     = 100
}

variable "containerInsights" {
  type        = string
  description = "Enable to Disable the container insight"
  default     = "enabled"
}
variable "tag_specifications" {
  description = "The tags to apply to the resources during launch"
  type        = list(any)
  default     = []
}

variable "ignore_desired_capacity_changes" {
  description = "Determines whether the desired_capacity value is ignored after initial apply"
  type        = bool
  default     = true
}

variable "spot_instance_types" {
  default     = ["t4g.small"]
  type        = list(string)
  description = <<EOT
List of instance types to use in the Spot Auto Scaling Group.

💡 The order of instance types matters:
- The first instance type has the highest priority.
- Subsequent types are used as fallbacks in case the preferred type is unavailable.

Example: ["t4g.small", "t4g.medium", "t4g.large"]
EOT
}

variable "spot_allocation_strategy" {
  default     = "price-capacity-optimized"
  type        = string
  description = "How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized, capacity-optimized-prioritized, and price-capacity-optimized."
  validation {
    condition     = contains(["lowest-price", "capacity-optimized", "capacity-optimized-prioritized", "price-capacity-optimized"], var.spot_allocation_strategy)
    error_message = "Invalid Allocation Strategy. Allowed values are lowest-price, capacity-optimized, capacity-optimized-prioritized, and price-capacity-optimized."
  }
}

variable "spot_min_size" {
  default     = "1"
  type        = number
  description = "Enter the min spot instance to run in ASG"
}

variable "spot_max_size" {
  default     = "5"
  type        = number
  description = "Enter the max spot instance to run in ASG"
}

variable "spot_desired_size" {
  default     = "1"
  type        = number
  description = "Enter the desired bumber of spot instance to run in ASG"
}

variable "on_demand_capacity_base" {
  default     = "1"
  type        = number
  description = "The number of tasks, at a minimum, to run on the on-demand capacity provider."
}

variable "spot_capacity_base" {
  default     = "0"
  type        = number
  description = "The number of tasks, at a minimum, to run on the on-demand capacity provider."
}

variable "on_demand_capacity_weight" {
  default     = "100"
  type        = number
  description = "The relative percentage of the total number of launched tasks that should use the on-demand capacity provider."
}

variable "spot_capacity_weight" {
  default     = "0"
  type        = number
  description = "The relative percentage of the total number of launched tasks that should use the on-demand capacity provider."
}

variable "enabled_metrics" {
  type        = list(string)
  description = "List of metrics to collect"
  default     = ["GroupDesiredCapacity", "GroupInServiceInstances", "GroupMaxSize", "GroupMinSize", "GroupPendingInstances", "GroupStandbyInstances", "GroupTerminatingInstances", "GroupTotalInstances"]
}

variable "tags" {
  description = "A map of tags to assign to resources"
  type        = map(string)
  default     = {}
}

variable "instance_name" {
  description = "Name that is propogated to launched EC2 instances via a tag - if not provided, defaults to `var.name`"
  type        = string
  default     = ""
}

variable "name" {
  description = "Name used across the resources created"
  type        = string
  default     = "marketplace"
}

variable "autoscaling_group_tags" {
  description = "A map of additional tags to add to the autoscaling group"
  type        = map(string)
  default     = {}
}

variable "launch_template_version" {
  description = "Launch template version. Can be version number, `$Latest`, or `$Default`"
  type        = string
  default     = null
}

variable "architecture" {
  description = "AMI architecture valid values are arm64 and x86_64"
  type = list(string)
  default = ["arm64"]
}