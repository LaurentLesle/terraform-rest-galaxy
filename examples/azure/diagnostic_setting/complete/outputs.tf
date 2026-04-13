output "azure_diagnostic_settings" {
  description = "Map of Diagnostic Setting outputs from the root module."
  value       = module.root.azure_values.azure_diagnostic_settings
}
