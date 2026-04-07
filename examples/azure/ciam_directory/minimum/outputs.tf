output "azure_ciam_directories" {
  description = "Map of CIAM directory outputs from the root module, keyed by instance name."
  value       = module.root.azure_values.azure_ciam_directories
}
