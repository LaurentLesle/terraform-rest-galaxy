output "id" {
  value       = local.pe_path
  description = "The resource ID of the private endpoint (plan-time)."
}

output "name" {
  value       = var.private_endpoint_name
  description = "The name of the private endpoint."
}

output "location" {
  value       = var.location
  description = "The Azure region."
}

output "provisioning_state" {
  value       = try(rest_resource.private_endpoint.output.properties.provisioningState, null)
  description = "The provisioning state (known after apply)."
}
