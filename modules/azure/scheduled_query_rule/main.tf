# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2026-03-01
#   swagger    : scheduledQueryRule_API.json
#   operation  : ScheduledQueryRules_CreateOrUpdate (PUT, synchronous)
#   delete     : ScheduledQueryRules_Delete (DELETE, synchronous)

locals {
  api_version = "2026-03-01"
  sqr_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/scheduledQueryRules/${var.rule_name}"

  identity = var.identity_type != null ? merge(
    { type = var.identity_type },
    var.identity_user_assigned_identity_ids != null ? {
      userAssignedIdentities = { for id in var.identity_user_assigned_identity_ids : id => {} }
    } : {},
  ) : null

  criteria_body = {
    allOf = [
      for c in var.criteria.all_of : merge(
        c.query != null ? { query = c.query } : {},
        c.time_aggregation != null ? { timeAggregation = c.time_aggregation } : {},
        c.metric_measure_column != null ? { metricMeasureColumn = c.metric_measure_column } : {},
        c.resource_id_column != null ? { resourceIdColumn = c.resource_id_column } : {},
        c.operator != null ? { operator = c.operator } : {},
        c.threshold != null ? { threshold = c.threshold } : {},
        c.failing_periods != null ? {
          failingPeriods = {
            numberOfEvaluationPeriods = c.failing_periods.number_of_evaluation_periods
            minFailingPeriodsToAlert  = c.failing_periods.min_failing_periods_to_alert
          }
        } : {},
        c.dimensions != null ? {
          dimensions = [
            for d in c.dimensions : {
              name     = d.name
              operator = d.operator
              values   = d.values
            }
          ]
        } : {},
      )
    ]
  }

  actions_body = var.actions != null ? merge(
    length(try(var.actions.action_groups, [])) > 0 ? { actionGroups = var.actions.action_groups } : {},
    try(var.actions.custom_properties, null) != null ? { customProperties = var.actions.custom_properties } : {},
    try(var.actions.action_properties, null) != null ? { actionProperties = var.actions.action_properties } : {},
  ) : null

  properties = merge(
    {
      scopes   = var.scopes
      criteria = local.criteria_body
      enabled  = var.enabled
    },
    var.description != null ? { description = var.description } : {},
    var.display_name != null ? { displayName = var.display_name } : {},
    var.severity != null ? { severity = var.severity } : {},
    var.evaluation_frequency != null ? { evaluationFrequency = var.evaluation_frequency } : {},
    var.window_size != null ? { windowSize = var.window_size } : {},
    var.override_query_time_range != null ? { overrideQueryTimeRange = var.override_query_time_range } : {},
    var.target_resource_types != null ? { targetResourceTypes = var.target_resource_types } : {},
    var.mute_actions_duration != null ? { muteActionsDuration = var.mute_actions_duration } : {},
    local.actions_body != null ? { actions = local.actions_body } : {},
    { checkWorkspaceAlertsStorageConfigured = var.check_workspace_alerts_storage_configured },
    { skipQueryValidation = var.skip_query_validation },
    { autoMitigate = var.auto_mitigate },
    var.resolve_configuration != null ? {
      resolveConfiguration = merge(
        var.resolve_configuration.auto_resolved != null ? { autoResolved = var.resolve_configuration.auto_resolved } : {},
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
    var.kind != null ? { kind = var.kind } : {},
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

resource "rest_resource" "scheduled_query_rule" {
  path            = local.sqr_path
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
    "properties.createdWithApiVersion",
    "properties.isWorkspaceAlertsStorageConfigured",
  ])

  # PUT and DELETE are synchronous — no polling needed.
}
