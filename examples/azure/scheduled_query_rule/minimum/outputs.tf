output "azure_scheduled_query_rules" {
  description = "Map of Scheduled Query Rule outputs from the root module."
  value       = module.root.azure_values.azure_scheduled_query_rules
}
