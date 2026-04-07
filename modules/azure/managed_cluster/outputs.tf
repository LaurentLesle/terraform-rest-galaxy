output "id" {
  description = "The full ARM resource ID of the managed cluster."
  value       = local.cluster_path
}

output "name" {
  description = "The name of the managed cluster (plan-time, echoes input)."
  value       = var.cluster_name
}

output "location" {
  description = "The location of the managed cluster (plan-time, echoes input)."
  value       = var.location
}

output "provisioning_state" {
  description = "The provisioning state."
  value       = try(rest_resource.managed_cluster.output.properties.provisioningState, null)
}

output "fqdn" {
  description = "The FQDN of the cluster (public clusters only)."
  value       = try(rest_resource.managed_cluster.output.properties.fqdn, null)
}

output "private_fqdn" {
  description = "The private FQDN of the cluster (private clusters only)."
  value       = try(rest_resource.managed_cluster.output.properties.privateFQDN, null)
}

output "oidc_issuer_url" {
  description = "The OIDC issuer URL."
  value       = try(rest_resource.managed_cluster.output.properties.oidcIssuerProfile.issuerURL, null)
}

output "kubelet_identity_object_id" {
  description = "The kubelet managed identity object ID."
  value       = try(rest_resource.managed_cluster.output.properties.identityProfile.kubeletidentity.objectId, null)
}

output "kubelet_identity_client_id" {
  description = "The kubelet managed identity client ID."
  value       = try(rest_resource.managed_cluster.output.properties.identityProfile.kubeletidentity.clientId, null)
}

output "identity_principal_id" {
  description = "The principal ID of the cluster system-assigned identity."
  value       = try(rest_resource.managed_cluster.output.identity.principalId, null)
}

output "identity_tenant_id" {
  description = "The tenant ID of the cluster system-assigned identity."
  value       = try(rest_resource.managed_cluster.output.identity.tenantId, null)
}

output "get_credentials_command" {
  description = "az CLI command to get kubeconfig (user role-based access)."
  value       = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.cluster_name}"
}

output "get_admin_credentials_command" {
  description = "az CLI command to get admin kubeconfig (full cluster access)."
  value       = "az aks get-credentials --resource-group ${var.resource_group_name} --name ${var.cluster_name} --admin"
}
