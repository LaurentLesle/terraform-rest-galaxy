output "management_groups" {
  description = "The management group outputs."
  value       = module.root.azure_values.azure_management_groups
}
