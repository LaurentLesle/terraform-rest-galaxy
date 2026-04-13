# Source: azure-rest-api-specs
#   spec_path  : resources/resource-manager/Microsoft.Authorization/policy
#   api_version: 2025-11-01
#   operation  : PolicyDefinitions_CreateOrUpdateAtManagementGroup (PUT, synchronous)
#               PolicyDefinitions_CreateOrUpdate                   (PUT, synchronous) — subscription scope
#   delete     : PolicyDefinitions_DeleteAtManagementGroup         (DELETE, synchronous)
#               PolicyDefinitions_Delete                           (DELETE, synchronous)
#
# Path routing:
#   Management group scope: /providers/Microsoft.Management/managementGroups/{mgId}/providers/Microsoft.Authorization/policyDefinitions/{name}
#   Subscription scope:     /subscriptions/{subId}/providers/Microsoft.Authorization/policyDefinitions/{name}

locals {
  api_version = "2025-11-01"
  pd_path     = "${var.scope}/providers/Microsoft.Authorization/policyDefinitions/${var.policy_definition_name}"

  properties = merge(
    {
      policyType  = var.policy_type
      mode        = var.mode
      displayName = var.display_name
      policyRule  = var.policy_rule
    },
    var.description != null ? { description = var.description } : {},
    var.metadata != null ? { metadata = var.metadata } : {},
    var.parameters != null ? { parameters = var.parameters } : {},
  )

  body = {
    properties = local.properties
  }
}

resource "rest_resource" "policy_definition" {
  path            = local.pd_path
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
    "properties.policyType",
    "properties.mode",
    "properties.displayName",
    "properties.description",
    "properties.metadata",
    "properties.parameters",
    "properties.policyRule",
  ])
}
