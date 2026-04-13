output "azure_alert_processing_rules" {
  description = "Map of Alert Processing Rule outputs from the root module."
  value       = module.root.azure_values.azure_alert_processing_rules
}
