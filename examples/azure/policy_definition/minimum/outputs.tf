output "policy_definitions" {
  description = "The custom policy definition outputs."
  value       = module.root.azure_values.azure_policy_definitions
}
