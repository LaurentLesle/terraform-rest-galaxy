output "id" {
  description = "The full ARM resource ID of the policy assignment."
  value       = local.assignment_path
}

output "name" {
  description = "The name of the policy assignment."
  value       = var.assignment_name
}

output "display_name" {
  description = "The display name of the policy assignment."
  value       = try(rest_resource.policy_assignment.output.properties.displayName, var.display_name)
}

output "scope" {
  description = "The scope the policy is assigned to."
  value       = try(rest_resource.policy_assignment.output.properties.scope, var.scope)
}

output "enforcement_mode" {
  description = "The enforcement mode of the policy assignment."
  value       = try(rest_resource.policy_assignment.output.properties.enforcementMode, var.enforcement_mode)
}

output "policy_definition_id" {
  description = "The policy definition ID this assignment references."
  value       = try(rest_resource.policy_assignment.output.properties.policyDefinitionId, var.policy_definition_id)
}

output "principal_id" {
  description = "The principal ID of the managed identity associated with the assignment (if any)."
  value       = try(rest_resource.policy_assignment.output.identity.principalId, null)
}

output "identity_type" {
  description = "The managed identity type of the assignment."
  value       = try(rest_resource.policy_assignment.output.identity.type, var.identity_type)
}
