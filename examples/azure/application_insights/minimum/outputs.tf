output "azure_application_insights" {
  description = "Map of Application Insights outputs from the root module."
  value       = module.root.azure_values.azure_application_insights
}
