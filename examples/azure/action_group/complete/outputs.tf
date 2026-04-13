output "azure_action_groups" {
  description = "Map of Action Group outputs from the root module."
  value       = module.root.azure_values.azure_action_groups
}
