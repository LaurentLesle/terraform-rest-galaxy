output "azure_subscriptions" {
  description = "Map of subscription outputs from the root module."
  value       = module.root.azure_values.azure_subscriptions
}
