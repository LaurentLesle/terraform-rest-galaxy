output "id" {
  description = "The full ARM resource ID of the scoped resource association (plan-time, built from inputs)."
  value       = local.scoped_resource_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The name of the scoped resource association (plan-time, echoes input)."
  value       = var.scoped_resource_name
}

output "provisioning_state" {
  description = "The provisioning state of the scoped resource association (known after apply)."
  value       = try(rest_resource.monitor_private_link_scoped_resource.output.properties.provisioningState, null)
}
