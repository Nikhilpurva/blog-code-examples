output "cluster_dns_name" {
  value       = aws_lb.service-lb.dns_name
  description = "DNS name of the load balancer"
}

output "lb_security_group" {
  value       = aws_security_group.lb_sg.id
  description = "LB security group ids"
}

output "cluster_alb_zone_id" {
  value       = aws_lb.service-lb.zone_id
  description = "Canonical hosted zone ID of the load balancer (to be used in a Route 53 Alias record)"
}