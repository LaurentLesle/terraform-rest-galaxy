# ── Plan-time known (echoes input) ────────────────────────────────────────────

output "id" {
  description = "The full ARM resource ID of the associated billing tenant."
  value       = local.path
}

output "billing_account_name" {
  description = "The billing account name (echoes input)."
  value       = var.billing_account_name
}

output "tenant_id" {
  description = "The associated tenant ID (echoes input)."
  value       = var.tenant_id
}

output "display_name" {
  description = "The friendly display name (echoes input)."
  value       = var.display_name
}

# ── Known after apply (Azure-assigned) ────────────────────────────────────────

output "provisioning_state" {
  description = "The provisioning state of the associated tenant."
  value       = try(rest_resource.billing_associated_tenant.output.properties.provisioningState, null)
}

output "billing_management_state" {
  description = "The billing management state of the associated tenant."
  value       = try(rest_resource.billing_associated_tenant.output.properties.billingManagementState, null)
}

output "provisioning_management_state" {
  description = "The provisioning management state of the associated tenant."
  value       = try(rest_resource.billing_associated_tenant.output.properties.provisioningManagementState, null)
}

output "provisioning_billing_request_id" {
  description = "The unique identifier for the billing request created when enabling provisioning."
  value       = try(rest_resource.billing_associated_tenant.output.properties.provisioningBillingRequestId, null)
}

output "approval_url" {
  description = "Portal URL for the target tenant's Global Admin to approve the provisioning request."
  value = (
    try(rest_resource.billing_associated_tenant.output.properties.provisioningBillingRequestId, null) != null
    ? "https://portal.azure.com/${var.tenant_id}#blade/Microsoft_Azure_GTM/PermissionRequestOverviewForReviewer.ReactView/permissionRequestId/${urlencode(replace(rest_resource.billing_associated_tenant.output.properties.provisioningBillingRequestId, "billingRequests", "permissionRequests"))}"
    : null
  )
}

# ── Access pre-check results ──────────────────────────────────────────────────

output "access_check_write" {
  description = "Whether the caller has write permission on associated tenants. Null if precheck_access is false."
  value       = var.precheck_access ? local._write_allowed : null
}

output "access_check_delete" {
  description = "Whether the caller has delete permission on associated tenants. Null if precheck_access is false."
  value       = var.precheck_access ? local._delete_allowed : null
}
