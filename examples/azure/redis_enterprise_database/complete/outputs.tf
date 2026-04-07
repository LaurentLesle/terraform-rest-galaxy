output "azure_redis_enterprise_databases" {
  description = "Map of redis enterprise database outputs from the root module."
  value       = module.root.azure_values.azure_redis_enterprise_databases
}
