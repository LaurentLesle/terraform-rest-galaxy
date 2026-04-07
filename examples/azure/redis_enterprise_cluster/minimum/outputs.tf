output "azure_redis_enterprise_clusters" {
  description = "Map of redis enterprise cluster outputs from the root module."
  value       = module.root.azure_values.azure_redis_enterprise_clusters
}
