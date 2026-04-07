output "id" {
  value       = local.lb_path
  description = "The resource ID of the load balancer (plan-time)."
}

output "name" {
  value       = var.load_balancer_name
  description = "The name of the load balancer."
}

output "location" {
  value       = var.location
  description = "The Azure region."
}

output "provisioning_state" {
  value       = try(rest_resource.load_balancer.output.properties.provisioningState, null)
  description = "The provisioning state (known after apply)."
}
