# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   api_version: 2023-01-01
#   swagger    : actionGroups_API.json
#   operation  : ActionGroups_CreateOrUpdate (PUT, synchronous)
#   delete     : ActionGroups_Delete (DELETE, synchronous)

locals {
  api_version = "2023-01-01"
  ag_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/actionGroups/${var.action_group_name}"

  email_receivers = [
    for r in var.email_receivers : {
      name                  = r.name
      emailAddress          = r.email_address
      useCommonAlertSchema  = r.use_common_alert_schema
    }
  ]

  sms_receivers = [
    for r in var.sms_receivers : {
      name        = r.name
      countryCode = r.country_code
      phoneNumber = r.phone_number
    }
  ]

  webhook_receivers = [
    for r in var.webhook_receivers : merge(
      {
        name                   = r.name
        serviceUri             = r.service_uri
        useCommonAlertSchema   = r.use_common_alert_schema
        useAadAuth             = r.use_aad_auth
      },
      r.object_id != null ? { objectId = r.object_id } : {},
      r.identifier_uri != null ? { identifierUri = r.identifier_uri } : {},
      r.tenant_id != null ? { tenantId = r.tenant_id } : {},
    )
  ]

  itsm_receivers = [
    for r in var.itsm_receivers : {
      name                = r.name
      workspaceId         = r.workspace_id
      connectionId        = r.connection_id
      ticketConfiguration = r.ticket_configuration
      region              = r.region
    }
  ]

  azure_app_push_receivers = [
    for r in var.azure_app_push_receivers : {
      name         = r.name
      emailAddress = r.email_address
    }
  ]

  automation_runbook_receivers = [
    for r in var.automation_runbook_receivers : merge(
      {
        automationAccountId  = r.automation_account_id
        runbookName          = r.runbook_name
        webhookResourceId    = r.webhook_resource_id
        isGlobalRunbook      = r.is_global_runbook
        name                 = r.name
        useCommonAlertSchema = r.use_common_alert_schema
      },
      r.service_uri != null ? { serviceUri = r.service_uri } : {},
    )
  ]

  voice_receivers = [
    for r in var.voice_receivers : {
      name        = r.name
      countryCode = r.country_code
      phoneNumber = r.phone_number
    }
  ]

  logic_app_receivers = [
    for r in var.logic_app_receivers : {
      name                  = r.name
      resourceId            = r.resource_id
      callbackUrl           = r.callback_url
      useCommonAlertSchema  = r.use_common_alert_schema
    }
  ]

  azure_function_receivers = [
    for r in var.azure_function_receivers : {
      name                    = r.name
      functionAppResourceId   = r.function_app_resource_id
      functionName            = r.function_name
      httpTriggerUrl          = r.http_trigger_url
      useCommonAlertSchema    = r.use_common_alert_schema
    }
  ]

  arm_role_receivers = [
    for r in var.arm_role_receivers : {
      name                  = r.name
      roleId                = r.role_id
      useCommonAlertSchema  = r.use_common_alert_schema
    }
  ]

  event_hub_receivers = [
    for r in var.event_hub_receivers : merge(
      {
        name                  = r.name
        eventHubNameSpace     = r.event_hub_namespace
        eventHubName          = r.event_hub_name
        subscriptionId        = r.subscription_id
        useCommonAlertSchema  = r.use_common_alert_schema
      },
      r.tenant_id != null ? { tenantId = r.tenant_id } : {},
    )
  ]

  properties = merge(
    {
      groupShortName = var.short_name
      enabled        = var.enabled
    },
    length(local.email_receivers) > 0 ? { emailReceivers = local.email_receivers } : {},
    length(local.sms_receivers) > 0 ? { smsReceivers = local.sms_receivers } : {},
    length(local.webhook_receivers) > 0 ? { webhookReceivers = local.webhook_receivers } : {},
    length(local.itsm_receivers) > 0 ? { itsmReceivers = local.itsm_receivers } : {},
    length(local.azure_app_push_receivers) > 0 ? { azureAppPushReceivers = local.azure_app_push_receivers } : {},
    length(local.automation_runbook_receivers) > 0 ? { automationRunbookReceivers = local.automation_runbook_receivers } : {},
    length(local.voice_receivers) > 0 ? { voiceReceivers = local.voice_receivers } : {},
    length(local.logic_app_receivers) > 0 ? { logicAppReceivers = local.logic_app_receivers } : {},
    length(local.azure_function_receivers) > 0 ? { azureFunctionReceivers = local.azure_function_receivers } : {},
    length(local.arm_role_receivers) > 0 ? { armRoleReceivers = local.arm_role_receivers } : {},
    length(local.event_hub_receivers) > 0 ? { eventHubReceivers = local.event_hub_receivers } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "action_group" {
  path            = local.ag_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.enabled",
    "properties.groupShortName",
  ])

  # PUT and DELETE are synchronous — no polling needed.
}
