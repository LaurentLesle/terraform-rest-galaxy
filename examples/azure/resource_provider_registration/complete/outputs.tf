output "azure_resource_provider_registrations" {
  description = "Map of resource provider registration outputs from the root module."
  value       = module.root.azure_values.azure_resource_provider_registrations
}
