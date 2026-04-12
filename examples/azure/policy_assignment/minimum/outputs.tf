output "policy_assignments" {
  description = "The policy assignment outputs."
  value       = module.root.azure_values.azure_policy_assignments
}
