# Source: Microsoft Graph API
#   api        : Microsoft Graph v1.0
#   resource   : appRoleAssignment
#   create     : POST   /v1.0/servicePrincipals/{id}/appRoleAssignedTo  (synchronous)
#   read       : GET    /v1.0/servicePrincipals/{id}/appRoleAssignedTo/{assignment-id}
#   delete     : DELETE /v1.0/servicePrincipals/{id}/appRoleAssignedTo/{assignment-id}
#
# This module assigns a user, group, or service principal to an Enterprise
# Application (service principal) via an app role assignment. It first looks
# up the service principal by its appId, then creates the assignment.

# ── Look up the service principal object ID from the app (client) ID ─────────
data "rest_resource" "service_principal" {
  id = "/v1.0/servicePrincipals"

  query = {
    "$filter" = ["appId eq '${var.resource_app_id}'"]
    "$select" = ["id,appId,displayName"]
  }

  # The response is { "value": [ { "id": "...", ... } ] }
  # We need the first element's id.
  output_attrs = toset([
    "value",
  ])
}

locals {
  # Extract the service principal object ID from the filter response
  resource_id = data.rest_resource.service_principal.output.value[0].id
}

# ── Create the app role assignment ───────────────────────────────────────────
resource "rest_resource" "app_role_assignment" {
  path          = "/v1.0/servicePrincipals/${local.resource_id}/appRoleAssignedTo"
  create_method = "POST"

  read_path   = "/v1.0/servicePrincipals/${local.resource_id}/appRoleAssignedTo/$(body.id)"
  delete_path = "/v1.0/servicePrincipals/${local.resource_id}/appRoleAssignedTo/$(body.id)"

  body = {
    principalId = var.principal_id
    resourceId  = local.resource_id
    appRoleId   = var.app_role_id
  }

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
    "principalDisplayName",
    "principalType",
    "resourceDisplayName",
  ])
}
