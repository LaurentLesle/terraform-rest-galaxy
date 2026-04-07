output "azure_role_assignments" {
  description = "Map of role assignment outputs from the root module."
  value       = module.root.azure_values.azure_role_assignments
}
