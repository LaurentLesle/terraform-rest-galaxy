output "id" {
  description = "The full ARM resource ID of the connected cluster."
  value       = local.cc_path
}

output "api_version" {
  description = "The ARM API version used to manage this connected cluster."
  value       = local.api_version
}

output "cluster_name" {
  description = "The name of the connected cluster (echoes input)."
  value       = var.cluster_name
}

output "location" {
  description = "The location of the connected cluster (echoes input)."
  value       = var.location
}

output "provisioning_state" {
  description = "The provisioning state of the connected cluster."
  value       = try(rest_resource.connected_cluster.output.properties.provisioningState, null)
}

output "kubernetes_version" {
  description = "The Kubernetes version reported by the connected cluster."
  value       = try(rest_resource.connected_cluster.output.properties.kubernetesVersion, null)
}

output "total_node_count" {
  description = "The total number of nodes in the connected cluster."
  value       = try(rest_resource.connected_cluster.output.properties.totalNodeCount, null)
}

output "agent_version" {
  description = "The version of the Arc agent."
  value       = try(rest_resource.connected_cluster.output.properties.agentVersion, null)
}

output "connectivity_status" {
  description = "The connectivity status (Connecting, Connected, Offline, Expired)."
  value       = try(rest_operation.wait_for_connection[0].output.properties.connectivityStatus, rest_resource.connected_cluster.output.properties.connectivityStatus, null)
}

output "principal_id" {
  description = "The principal ID of the system-assigned managed identity."
  value       = try(rest_resource.connected_cluster.output.identity.principalId, null)
}

output "tenant_id" {
  description = "The tenant ID of the system-assigned managed identity."
  value       = try(rest_resource.connected_cluster.output.identity.tenantId, null)
}

output "type" {
  description = "The resource type string returned by ARM."
  value       = try(rest_resource.connected_cluster.output.type, null)
}

output "tags" {
  description = "The tags on the connected cluster."
  value       = try(rest_resource.connected_cluster.output.tags, null)
}

output "subscription_id" {
  description = "The subscription ID (echoes input)."
  value       = var.subscription_id
}

output "resource_group_name" {
  description = "The resource group name (echoes input)."
  value       = var.resource_group_name
}
