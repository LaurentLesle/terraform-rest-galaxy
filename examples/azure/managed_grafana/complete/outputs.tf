output "azure_managed_grafanas" {
  description = "Map of Managed Grafana outputs from the root module."
  value       = module.root.azure_values.azure_managed_grafanas
}
