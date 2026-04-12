# Source: azure-rest-api-specs
#   spec_path  : resources/resource-manager/Microsoft.Authorization/policy
#   api_version: 2025-11-01
#   operation  : PolicySetDefinitions_CreateOrUpdateAtManagementGroup (PUT, synchronous)
#               PolicySetDefinitions_CreateOrUpdate                   (PUT, synchronous) — subscription scope
#   delete     : PolicySetDefinitions_DeleteAtManagementGroup         (DELETE, synchronous)
#               PolicySetDefinitions_Delete                           (DELETE, synchronous)
#
# Path routing:
#   Management group scope: /providers/Microsoft.Management/managementGroups/{mgId}/providers/Microsoft.Authorization/policySetDefinitions/{name}
#   Subscription scope:     /subscriptions/{subId}/providers/Microsoft.Authorization/policySetDefinitions/{name}

locals {
  api_version = "2025-11-01"
  psd_path    = "${var.scope}/providers/Microsoft.Authorization/policySetDefinitions/${var.policy_set_definition_name}"

  # Build the policyDefinitions list for the ARM body
  policy_definitions_body = [
    for pd in var.policy_definitions : merge(
      { policyDefinitionId = pd.policy_definition_id },
      try(pd.policy_definition_reference_id, null) != null ? { policyDefinitionReferenceId = pd.policy_definition_reference_id } : {},
      try(pd.parameters, null) != null ? { parameters = pd.parameters } : {},
      try(pd.group_names, null) != null ? { groupNames = pd.group_names } : {},
    )
  ]

  # Build optional policy definition groups
  policy_definition_groups_body = length(var.policy_definition_groups) > 0 ? [
    for g in var.policy_definition_groups : merge(
      { name = g.name },
      g.display_name != null ? { displayName = g.display_name } : {},
      g.description != null ? { description = g.description } : {},
      g.additional_metadata != null ? { additionalMetadataId = g.additional_metadata } : {},
    )
  ] : null

  properties = merge(
    {
      policyType        = var.policy_type
      displayName       = var.display_name
      policyDefinitions = local.policy_definitions_body
    },
    var.description != null ? { description = var.description } : {},
    var.metadata != null ? { metadata = var.metadata } : {},
    var.parameters != null ? { parameters = var.parameters } : {},
    local.policy_definition_groups_body != null ? { policyDefinitionGroups = local.policy_definition_groups_body } : {},
  )

  body = {
    properties = local.properties
  }
}

resource "rest_resource" "policy_set_definition" {
  path            = local.psd_path
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
    "properties.displayName",
    "properties.description",
    "properties.metadata",
    "properties.policyDefinitions",
    "properties.policyDefinitionGroups",
  ])
}
