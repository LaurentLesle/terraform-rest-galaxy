output "id" {
  description = "The full ARM resource ID of the policy set definition (initiative)."
  value       = local.psd_path
}

output "name" {
  description = "The name of the policy set definition."
  value       = var.policy_set_definition_name
}

output "display_name" {
  description = "The display name of the policy set definition."
  value       = try(rest_resource.policy_set_definition.output.properties.displayName, var.display_name)
}

output "policy_type" {
  description = "The policy type."
  value       = try(rest_resource.policy_set_definition.output.properties.policyType, var.policy_type)
}
