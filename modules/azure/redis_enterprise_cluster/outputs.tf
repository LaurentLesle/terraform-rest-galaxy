output "id" {
  description = "The full ARM resource ID of the Redis Enterprise cluster."
  value       = local.cluster_path
}

output "api_version" {
  description = "The ARM API version used to manage this Redis Enterprise cluster."
  value       = local.api_version
}

output "name" {
  description = "The name of the Redis Enterprise cluster (plan-time, echoes input)."
  value       = var.cluster_name
}

output "location" {
  description = "The Azure region (plan-time, echoes input)."
  value       = var.location
}

output "resource_group_name" {
  description = "The resource group name (plan-time, echoes input)."
  value       = var.resource_group_name
}

output "hostname" {
  description = "The hostname of the Redis Enterprise cluster (known after apply)."
  value       = try(rest_resource.redis_enterprise_cluster.output.properties.hostName, null)
}

output "provisioning_state" {
  description = "The provisioning state of the Redis Enterprise cluster."
  value       = try(rest_resource.redis_enterprise_cluster.output.properties.provisioningState, null)
}

output "type" {
  description = "The ARM resource type string."
  value       = try(rest_resource.redis_enterprise_cluster.output.type, null)
}
