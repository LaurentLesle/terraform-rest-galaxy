# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2024-03-01-preview
#   swagger    : metricAlert_API.json
#   operation  : MetricAlerts_CreateOrUpdate (PUT, synchronous)
#   delete     : MetricAlerts_Delete (DELETE, synchronous)
#   stability  : preview

locals {
  api_version = "2024-03-01-preview"
  ma_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/metricAlerts/${var.metric_alert_name}"

  actions_body = [
    for a in var.actions : merge(
      { actionGroupId = a.action_group_id },
      a.webhook_properties != null ? { webhookProperties = a.webhook_properties } : {},
    )
  ]

  identity = var.identity_type != null ? merge(
    { type = var.identity_type },
    var.identity_user_assigned_identity_ids != null ? {
      userAssignedIdentities = { for id in var.identity_user_assigned_identity_ids : id => {} }
    } : {},
  ) : null

  properties = merge(
    {
      enabled             = var.enabled
      severity            = var.severity
      scopes              = var.scopes
      evaluationFrequency = var.evaluation_frequency
      criteria            = var.criteria
      autoMitigate        = var.auto_mitigate
    },
    var.description != null ? { description = var.description } : {},
    var.window_size != null ? { windowSize = var.window_size } : {},
    var.target_resource_type != null ? { targetResourceType = var.target_resource_type } : {},
    var.target_resource_region != null ? { targetResourceRegion = var.target_resource_region } : {},
    length(local.actions_body) > 0 ? { actions = local.actions_body } : {},
    var.custom_properties != null ? { customProperties = var.custom_properties } : {},
    var.action_properties != null ? { actionProperties = var.action_properties } : {},
    var.resolve_configuration != null ? {
      resolveConfiguration = merge(
        { autoResolved = var.resolve_configuration.auto_resolved },
        var.resolve_configuration.time_to_resolve != null ? { timeToResolve = var.resolve_configuration.time_to_resolve } : {},
      )
    } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
    local.identity != null ? { identity = local.identity } : {},
  )
}

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Insights"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "metric_alert" {
  path            = local.ma_path
  create_method   = "PUT"
  check_existance = var.check_existance

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Insights is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    insights:\n      resource_provider_namespace: Microsoft.Insights"
    }
  }


  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.enabled",
    "properties.severity",
    "properties.lastUpdatedTime",
  ])

  # PUT and DELETE are synchronous — no polling needed.
}
