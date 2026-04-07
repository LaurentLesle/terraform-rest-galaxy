output "id" {
  description = "The full ARM resource ID of the CIAM directory."
  value       = local.ciam_path
}

output "api_version" {
  description = "The ARM API version used to manage this resource."
  value       = local.api_version
}

output "name" {
  description = "The resource name (echoes the input)."
  value       = var.resource_name
}

output "location" {
  description = "The data-residency location (echoes the input)."
  value       = var.location
}

# Read-only properties surfaced from the ARM GET response.

output "tenant_id" {
  description = "The Azure AD tenant ID of the CIAM directory."
  value       = try(rest_resource.ciam_directory.output.properties.tenantId, null)
}

output "domain_name" {
  description = "The domain name of the CIAM tenant."
  value       = try(rest_resource.ciam_directory.output.properties.domainName, null)
}

output "provisioning_state" {
  description = "The provisioning state of the CIAM directory (e.g. Succeeded)."
  value       = try(rest_resource.ciam_directory.output.properties.provisioningState, null)
}

output "billing_type" {
  description = "The billing type of the CIAM tenant (e.g. MAU)."
  value       = try(rest_resource.ciam_directory.output.properties.billingConfig.billingType, null)
}

output "type" {
  description = "The resource type string (Microsoft.AzureActiveDirectory/ciamDirectories)."
  value       = try(rest_resource.ciam_directory.output.type, null)
}

output "tags" {
  description = "The resource tags (as returned by ARM)."
  value       = try(rest_resource.ciam_directory.output.tags, null)
}
