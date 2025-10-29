# SHARED VARIABLES ============================================================
variable "application" {
  type        = string
  description = "Application name."
  default     = ""
}

variable "environment" {
  type        = string
  description = "The environment name."
}

variable "profile_name" {
  type        = string
  description = "AWS Profile Name."
}

variable "region" {
  type        = string
  description = "AWS Region."
}

variable "vpc_id" {
  type        = string
  description = "The ID of the VPC."
  default     = ""
}

# TEMPLATE VARIABLES ==========================================================

variable "tag" {
  type        = string
  description = "Tag values to attach with all the resources"
  default     = ""
}

variable "on_demand_instance_type" {
  type        = string
  description = "Enter the ARM based Instance type"
  default     = "t4g.micro"
}

variable "service_linked_role" {
  description = "Service Linked Role ARN"
  type        = string
}

variable "container_image" {
  type        = string
  description = "Container image"
}

variable "container_image_version" {
  type        = string
  description = "Container image version"
  default     = "latest"
}

variable "cpu" {
  type        = number
  description = "CPU assigned to a task"
  default     = 512
}

variable "memory" {
  type        = number
  description = "Memmory assigned to a task"
  default     = 512
}

variable "container_port" {
  type        = number
  description = "Container port"
  default     = 80
}

variable "health_check_path" {
  type    = string
  default = "/healthcheck"
}

variable "cidr_blocks" {
  type        = list(any)
  description = "Enter the CIDR block to allow 80 and 443 for ALB"
  default     = ["0.0.0.0/0"]
}

variable "cidr_block_descriptions" {
  type        = list(string)
  description = "Enter the CIDR block description(s)"
  default     = ["Allow all traffic"]
}

variable "desired_ecs_task" {
  type        = number
  description = "Number of desired ECS task in the service"
  default     = 1
}

variable "desired_ec2_capacity" {
  type        = string
  description = "Number of desired EC2 in the ASG"
  default     = "1"
}

variable "min_ecs_task" {
  type        = string
  description = "Number of minimum tasks to run in the service"
}

variable "max_ecs_task" {
  type        = number
  description = "Number of maximum tasks to run in the service"
}

variable "on_demand_desired_capacity" {
  type        = string
  description = "Number of desired EC2 in the ASG"
  default     = "1"
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

variable "acm_cert_arn" {
  type        = string
  description = "ACM certificate to be used for the distribution. All TI  domains can use this same cert as it has subject alternative names (SAN) for all TI domains"
  default     = "value"
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
  default     = "0"
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

variable "spot_allocation_strategy" {
  default     = "price-capacity-optimized"
  type        = string
  description = "How to allocate capacity across the Spot pools. Valid values: lowest-price, capacity-optimized, capacity-optimized-prioritized, and price-capacity-optimized."
  validation {
    condition     = contains(["lowest-price", "capacity-optimized", "capacity-optimized-prioritized", "price-capacity-optimized"], var.spot_allocation_strategy)
    error_message = "Invalid Allocation Strategy. Allowed values are lowest-price, capacity-optimized, capacity-optimized-prioritized, and price-capacity-optimized."
  }
}