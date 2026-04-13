# Source: azure-rest-api-specs
#   spec_path  : resources/resource-manager/Microsoft.Authorization/policy
#   api_version: 2025-11-01
#   operation  : PolicyAssignments_Create (PUT, synchronous)
#   delete     : PolicyAssignments_Delete (DELETE, synchronous)
#
# Path: {scope}/providers/Microsoft.Authorization/policyAssignments/{assignmentName}
# The scope is arbitrary — management group, subscription, resource group, or resource.

locals {
  api_version     = "2025-11-01"
  assignment_path = "${var.scope}/providers/Microsoft.Authorization/policyAssignments/${var.assignment_name}"

  # Build managed identity block
  identity = var.identity_type != "None" ? merge(
    { type = var.identity_type },
    var.identity_type == "UserAssigned" && var.identity_user_assigned_id != null ? {
      userAssignedIdentities = {
        (var.identity_user_assigned_id) = {}
      }
    } : {},
  ) : null

  # Build non-compliance messages
  non_compliance_messages = length(var.non_compliance_messages) > 0 ? [
    for msg in var.non_compliance_messages : merge(
      { message = msg.message },
      msg.policy_definition_reference_id != null ? { policyDefinitionReferenceId = msg.policy_definition_reference_id } : {},
    )
  ] : null

  properties = merge(
    {
      policyDefinitionId = var.policy_definition_id
      enforcementMode    = var.enforcement_mode
    },
    var.display_name != null ? { displayName = var.display_name } : {},
    var.description != null ? { description = var.description } : {},
    var.parameters != null ? { parameters = var.parameters } : {},
    length(var.not_scopes) > 0 ? { notScopes = var.not_scopes } : {},
    var.metadata != null ? { metadata = var.metadata } : {},
    local.non_compliance_messages != null ? { nonComplianceMessages = local.non_compliance_messages } : {},
  )

  body = merge(
    { properties = local.properties },
    local.identity != null ? { identity = local.identity } : {},
    var.location != null ? { location = var.location } : {},
  )
}

resource "rest_resource" "policy_assignment" {
  path            = local.assignment_path
  create_method   = "PUT"
  check_existance = var.check_existance
  auth_ref        = var.auth_ref

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "id",
    "name",
    "type",
    "properties.policyDefinitionId",
    "properties.displayName",
    "properties.enforcementMode",
    "properties.scope",
    "identity.type",
    "identity.principalId",
  ])

  # scope is embedded in the ARM path — any scope change means a new resource at a new path.
  # policyDefinitionId changes also require destroy+create per ARM semantics.
  force_new_attrs = toset([
    "properties.policyDefinitionId",
    "properties.scope",
  ])
}
