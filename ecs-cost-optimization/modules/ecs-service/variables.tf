variable "vpc_id" {
  type        = string
  description = "VPC id"
}

variable "cluster_name" {
  type        = string
  description = "Name of the Cluster"
}

variable "service_name" {
  type        = string
  description = "Name of the Service"
}


variable "cluster_id" {
  type        = string
  description = "Cluster ID"
}

variable "task_definition_arn" {
  type        = string
  description = "ARN of task definition"
}

variable "desired_ecs_task" {
  type        = string
  description = "Number of desired tasks to run in the service"
}


variable "capacity_provider_name" {
  type        = string
  description = "Number of the capacity provider"
}

variable "application" {
  type        = string
  description = "Application name"
}

variable "container_port" {
  type        = number
  description = "Container port number"
}

variable "public_subnet" {
  type        = list(any)
  description = "Public subnet"
}

variable "certificate_arn" {
  type        = string
  description = "Certificate ARN"
}

variable "lb_name" {
  type        = string
  description = "Loadbalancer Name"
}

variable "lb_internal" {
  type        = bool
  description = "Should Loadbalancer be in a private VPC"
  default     = false # false means LB will be publicly accessible
}

variable "lb_security_group_name" {
  type        = string
  description = "Loadbalancer Security Group Name"
}

variable "scaling_policy_name_mem" {
  type        = string
  description = "Scaling Policy Name for memory autoscaling policy"
  default     = ""
}

variable "scaling_policy_name_cpu" {
  type        = string
  description = "Scaling Policy Name for cpu autoscaling policy"
  default     = ""
}

variable "scaling_policy_memory_target_value" {
  type        = number
  description = "Target Value for Memory autoscaling policy "
  default     = 70
}

variable "scaling_policy_cpu_target_value" {
  type        = number
  description = "Target Value for CPU autoscaling policy "
  default     = 70
}

variable "target_group_name" {
  type        = string
  description = "Name of the Target Group"
}

variable "health_check_path" {
  type        = string
  description = "Path of Healthcheck"
  default     = "/"
}

variable "health_check_timeout" {
  type        = number
  description = "Healthcheck timeout"
  default     = 10
}

variable "http_code" {
  type        = string
  description = "HTTP code for healthcheck. Matches that used for EC2"
  default     = "200,302"
}

variable "target_type" {
  type        = string
  description = "Target group target type valid values: instance, ip"
  default     = "ip"
}

variable "routing_algorithm" {
  type        = string
  description = "Enter the routing algorithm, valid values are: least_outstanding_requests, round_robin"
  default     = "round_robin"
}

variable "network_mode" {
  type        = string
  description = "Enter the network mode"
  default     = "awsvpc"
}

variable "subnet_ids" {
  type        = list(string)
  description = "Enter the subnet ids"
  default     = null
}

variable "ecs_security_group_ids" {
  type        = list(string)
  description = "Enter the ecs host security group"
  default     = null
}

variable "enable_sticky_sessions" {
  type    = bool
  default = false # Set it to true when you want to enable sticky sessions
}

variable "sticky_sessions_cookie_duration" {
  type    = number
  default = "86400" # 
}

variable "enable_memory_scaling" {
  description = "Flag to enable or disable memory-based scaling policy"
  type        = bool
  default     = false // Default to false, meaning the policy is disabled by default
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

variable "min_ecs_task" {
  type        = string
  description = "Number of minimum tasks to run in the service"
}

variable "max_ecs_task" {
  type        = number
  description = "Number of maximum tasks to run in the service"
}

variable "idle_timeout" {
  type        = number
  description = "The time in seconds that the connection is allowed to be idle"
  default     = "60"
}

variable "environment" {
  type        = string
  description = "Type of environment like prod/stage/dev"
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