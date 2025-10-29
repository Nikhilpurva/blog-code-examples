output "cluster_arn" {
  value       = aws_ecs_cluster.ecs_cluster.arn
  description = "The arn for ECS cluster"
}

output "cluster_id" {
  value       = aws_ecs_cluster.ecs_cluster.id
  description = "The id for ECS cluster"
}

output "capacity_provider_name" {
  value       = aws_ecs_capacity_provider.capacity_provider.name
  description = "Name of the Capacity provider"
}

output "ecs_security_group" {
  value       = aws_security_group.ecs.id
  description = "ECS security group ids"
}

output "on_demand_asg_name" {
  value       = module.cluster-asg.autoscaling_group_name
  description = "Name of the on-demand autoscaling group"
}

output "spot_asg_name" {
  value       = aws_autoscaling_group.ecs_spot_asg.name
  description = "Name of the spot autoscaling group"
}