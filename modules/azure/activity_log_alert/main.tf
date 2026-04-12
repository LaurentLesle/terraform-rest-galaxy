# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2026-01-01
#   swagger    : activityLogAlerts_API.json
#   operation  : ActivityLogAlerts_CreateOrUpdate (PUT, synchronous)
#   delete     : ActivityLogAlerts_Delete (DELETE, synchronous)

locals {
  api_version = "2026-01-01"
  ala_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/activityLogAlerts/${var.activity_log_alert_name}"

  condition_body = {
    allOf = [
      for c in var.condition.all_of : merge(
        c.field != null ? { field = c.field } : {},
        c.equals != null ? { equals = c.equals } : {},
        c.contains_any != null ? { containsAny = c.contains_any } : {},
        c.any_of != null ? {
          anyOf = [
            for a in c.any_of : merge(
              a.field != null ? { field = a.field } : {},
              a.equals != null ? { equals = a.equals } : {},
            )
          ]
        } : {},
      )
    ]
  }

  actions_body = {
    actionGroups = [
      for ag in try(var.actions.action_groups, []) : merge(
        { actionGroupId = ag.action_group_id },
        ag.webhook_properties != null ? { webhookProperties = ag.webhook_properties } : {},
      )
    ]
  }

  properties = merge(
    {
      scopes    = var.scopes
      condition = local.condition_body
      actions   = local.actions_body
      enabled   = var.enabled
    },
    var.description != null ? { description = var.description } : {},
    var.tenant_scope != null ? { tenantScope = var.tenant_scope } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "activity_log_alert" {
  path            = local.ala_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.enabled",
  ])

  # PUT and DELETE are synchronous — no polling needed.
}
