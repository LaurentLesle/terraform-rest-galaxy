output "azure_resource_groups" {
  description = "Map of resource group outputs from the root module, keyed by instance name."
  value       = module.root.azure_values.azure_resource_groups
}
