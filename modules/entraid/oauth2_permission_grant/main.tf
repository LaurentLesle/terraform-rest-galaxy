# Source: Microsoft Graph API
#   api        : Microsoft Graph beta (required for service principal callers)
#   resource   : oauth2PermissionGrant
#   create     : POST   /beta/oauth2PermissionGrants  (synchronous)
#   read       : GET    /beta/oauth2PermissionGrants/{id}
#   delete     : DELETE /beta/oauth2PermissionGrants/{id}
#
# Grants admin consent (delegated permission grant) for a client application
# to access a resource API on behalf of all users in the tenant.
# This is the programmatic equivalent of clicking "Grant administrator consent"
# in the Azure Portal.
#
# NOTE: The /beta endpoint is used because /v1.0 does not support
# service principal callers (required for pipeline/automation scenarios).
#
# ── Required Permissions ─────────────────────────────────────────────────────
#
# Graph API permission (least privileged):
#   DelegatedPermissionGrant.ReadWrite.All   (Application or Delegated)
#
# Graph API permission (broader alternative):
#   Directory.ReadWrite.All                  (Application or Delegated)
#
# Entra ID role (least privileged, any of):
#   - Cloud Application Administrator
#   - Application Administrator
#
# Entra ID role (broader alternatives):
#   - Directory Writers
#   - Privileged Role Administrator
#   - User Administrator

locals {
  body = merge(
    {
      clientId    = var.client_id
      consentType = var.consent_type
      resourceId  = var.resource_id
      scope       = var.scope
      startTime   = var.start_time
      expiryTime  = var.expiry_time
    },
    var.principal_id != null ? { principalId = var.principal_id } : {},
  )
}

resource "rest_resource" "oauth2_permission_grant" {
  path          = "/beta/oauth2PermissionGrants"
  create_method = "POST"

  read_path   = "/beta/oauth2PermissionGrants/$(body.id)"
  delete_path = "/beta/oauth2PermissionGrants/$(body.id)"

  body = local.body

  poll_create = {
    status_locator    = "code"
    default_delay_sec = 5
    status = {
      success = ["200"]
      pending = ["404"]
    }
  }

  output_attrs = toset([
    "id",
    "clientId",
    "consentType",
    "resourceId",
    "scope",
  ])
}
