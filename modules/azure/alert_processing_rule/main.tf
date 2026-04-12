# Source: azure-rest-api-specs
#   spec_path  : alertsmanagement/resource-manager/Microsoft.AlertsManagement/AlertProcessingRules
#   api_version: 2021-08-08
#   swagger    : AlertProcessingRules.json (stable)
#   operation  : AlertProcessingRules_CreateOrUpdate (PUT, synchronous)
#   delete     : AlertProcessingRules_Delete (DELETE, synchronous)

locals {
  api_version = "2021-08-08"
  apr_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.AlertsManagement/actionRules/${var.alert_processing_rule_name}"

  conditions_body = [
    for c in var.conditions : {
      field    = c.field
      operator = c.operator
      values   = c.values
    }
  ]

  actions_body = [
    for a in var.actions : merge(
      { actionType = a.action_type },
      a.action_group_ids != null ? { actionGroupIds = a.action_group_ids } : {},
    )
  ]

  schedule_body = var.schedule != null ? merge(
    var.schedule.effective_from != null ? { effectiveFrom = var.schedule.effective_from } : {},
    var.schedule.effective_until != null ? { effectiveUntil = var.schedule.effective_until } : {},
    var.schedule.time_zone != null ? { timeZone = var.schedule.time_zone } : {},
    var.schedule.recurrences != null ? {
      recurrences = [
        for r in var.schedule.recurrences : merge(
          { recurrenceType = r.recurrence_type },
          r.start_time != null ? { startTime = r.start_time } : {},
          r.end_time != null ? { endTime = r.end_time } : {},
          r.days_of_week != null ? { daysOfWeek = r.days_of_week } : {},
          r.days_of_month != null ? { daysOfMonth = r.days_of_month } : {},
        )
      ]
    } : {},
  ) : null

  properties = merge(
    {
      scopes  = var.scopes
      actions = local.actions_body
      enabled = var.enabled
    },
    length(local.conditions_body) > 0 ? { conditions = local.conditions_body } : {},
    local.schedule_body != null ? { schedule = local.schedule_body } : {},
    var.description != null ? { description = var.description } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "alert_processing_rule" {
  path            = local.apr_path
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
