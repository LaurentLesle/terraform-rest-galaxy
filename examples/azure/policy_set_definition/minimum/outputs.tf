output "policy_set_definitions" {
  description = "The custom initiative (policy set definition) outputs."
  value       = module.root.azure_values.azure_policy_set_definitions
}
