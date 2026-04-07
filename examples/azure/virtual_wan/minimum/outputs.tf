output "azure_virtual_wans" {
  description = "Map of virtual wan outputs from the root module."
  value       = module.root.azure_values.azure_virtual_wans
}
