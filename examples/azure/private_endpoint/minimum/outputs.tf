output "azure_private_endpoints" {
  description = "Map of private endpoint outputs from the root module."
  value       = module.root.azure_values.azure_private_endpoints
}
