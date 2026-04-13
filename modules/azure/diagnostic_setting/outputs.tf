output "id" {
  description = "The full ARM resource ID of the diagnostic setting (plan-time known)."
  value       = local.ds_path
}

output "name" {
  description = "The name of the diagnostic setting (plan-time, echoes input)."
  value       = var.diagnostic_setting_name
}

output "api_version" {
  description = "The ARM API version used to manage this diagnostic setting."
  value       = local.api_version
}

output "provisioning_state" {
  description = "The provisioning state of the diagnostic setting."
  value       = try(rest_resource.diagnostic_setting.output.properties.provisioningState, null)
}
