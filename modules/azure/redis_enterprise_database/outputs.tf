output "id" {
  description = "The full ARM resource ID of the Redis Enterprise database."
  value       = local.db_path
}

output "api_version" {
  description = "The ARM API version used to manage this Redis Enterprise database."
  value       = local.api_version
}

output "name" {
  description = "The name of the database (plan-time, echoes input)."
  value       = var.database_name
}

output "cluster_name" {
  description = "The parent cluster name (plan-time, echoes input)."
  value       = var.cluster_name
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "port" {
  description = "The TCP port of the database endpoint (plan-time, echoes input)."
  value       = var.port
}

output "provisioning_state" {
  description = "The provisioning state of the database."
  value       = try(rest_resource.redis_enterprise_database.output.properties.provisioningState, null)
}

output "type" {
  description = "The ARM resource type string."
  value       = try(rest_resource.redis_enterprise_database.output.type, null)
}
