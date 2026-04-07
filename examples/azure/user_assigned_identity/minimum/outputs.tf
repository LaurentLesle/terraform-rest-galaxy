output "azure_user_assigned_identities" {
  description = "Map of user assigned identity outputs from the root module."
  value       = module.root.azure_values.azure_user_assigned_identities
}
