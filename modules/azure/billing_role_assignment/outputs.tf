locals {
  # Has a tracked rest_resource (EA always, MCA only when no pending billing request)
  _has_resource = !local.is_mca || (!local.is_invoice_section && var.billing_request_id == null)
  _res          = local._has_resource ? (local.is_mca ? rest_resource.mca_role_assignment[0] : rest_resource.ea_role_assignment[0]) : null
}

output "id" {
  description = "The full ARM resource ID of the billing role assignment."
  value       = local._has_resource ? local._res.id : null
}

output "api_version" {
  description = "The ARM API version used to manage this billing role assignment."
  value       = local.api_version
}

output "name" {
  description = "The GUID name of the billing role assignment."
  value       = local._has_resource ? try(local._res.output.name, null) : null
}

output "principal_id" {
  description = "The principal ID of the billing role assignment."
  value       = local._has_resource ? try(local._res.output.properties.principalId, null) : var.principal_id
}

output "role_definition_id" {
  description = "The role definition ID of the billing role assignment."
  value       = local._has_resource ? try(local._res.output.properties.roleDefinitionId, null) : var.role_definition_id
}

output "scope" {
  description = "The scope of the billing role assignment."
  value       = local._has_resource ? try(local._res.output.properties.scope, null) : local.scope
}

output "provisioning_state" {
  description = "The provisioning state of the billing role assignment."
  value       = local._has_resource ? try(local._res.output.properties.provisioningState, null) : "PendingApproval"
}

output "billing_request_id" {
  description = "The billing request ID when the role assignment requires approval."
  value = var.billing_request_id != null ? var.billing_request_id : (
    local.is_invoice_section ? try(rest_operation.mca_invoice_section_role_request[0].output.properties.billingRequestId, null) : null
  )
}
