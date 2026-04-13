output "azure_metric_alerts" {
  description = "Map of Metric Alert outputs from the root module."
  value       = module.root.azure_values.azure_metric_alerts
}
