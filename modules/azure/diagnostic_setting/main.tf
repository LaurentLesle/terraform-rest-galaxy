# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2021-05-01-preview
#   swagger    : diagnosticsSettings_API.json
#   operation  : DiagnosticSettings_CreateOrUpdate (PUT, synchronous)
#   delete     : DiagnosticSettings_Delete (DELETE, synchronous)
#   stability  : preview (no stable version for resource-scoped diagnostic settings)

locals {
  api_version = "2021-05-01-preview"

  # Path is relative to the target resource — no subscription_id here
  ds_path = "${var.resource_id}/providers/Microsoft.Insights/diagnosticSettings/${var.diagnostic_setting_name}"

  logs_body = [
    for l in var.logs : merge(
      l.category != null ? { category = l.category } : {},
      l.category_group != null ? { categoryGroup = l.category_group } : {},
      { enabled = l.enabled },
      l.retention_enabled != null ? {
        retentionPolicy = merge(
          { enabled = l.retention_enabled },
          l.retention_days != null ? { days = l.retention_days } : {},
        )
      } : {},
    )
  ]

  metrics_body = [
    for m in var.metrics : merge(
      { category = m.category },
      { enabled = m.enabled },
      m.retention_enabled != null ? {
        retentionPolicy = merge(
          { enabled = m.retention_enabled },
          m.retention_days != null ? { days = m.retention_days } : {},
        )
      } : {},
    )
  ]

  properties = merge(
    var.storage_account_id != null ? { storageAccountId = var.storage_account_id } : {},
    var.event_hub_authorization_rule_id != null ? { eventHubAuthorizationRuleId = var.event_hub_authorization_rule_id } : {},
    var.event_hub_name != null ? { eventHubName = var.event_hub_name } : {},
    var.log_analytics_workspace_id != null ? { workspaceId = var.log_analytics_workspace_id } : {},
    var.marketplace_partner_id != null ? { marketplacePartnerId = var.marketplace_partner_id } : {},
    var.service_bus_rule_id != null ? { serviceBusRuleId = var.service_bus_rule_id } : {},
    var.log_analytics_destination_type != null ? { logAnalyticsDestinationType = var.log_analytics_destination_type } : {},
    length(local.logs_body) > 0 ? { logs = local.logs_body } : {},
    length(local.metrics_body) > 0 ? { metrics = local.metrics_body } : {},
  )

  body = {
    properties = local.properties
  }
}

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Insights"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "diagnostic_setting" {
  path            = local.ds_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.storageAccountId",
    "properties.workspaceId",
    "properties.eventHubAuthorizationRuleId",
    "properties.eventHubName",
  ])

  # PUT and DELETE are synchronous — no polling needed.

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Insights is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    insights:\n      resource_provider_namespace: Microsoft.Insights"
    }
  }
}
