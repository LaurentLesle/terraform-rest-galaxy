# Source: azure-rest-api-specs
#   spec_path : communication/resource-manager/Microsoft.Communication
#   api_version: 2026-03-18
#   operation  : Domains_CreateOrUpdate  (PUT, async — azure-async-operation)
#   delete     : Domains_Delete          (DELETE, async — location)

locals {
  api_version = "2026-03-18"
  domain_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Communication/emailServices/${var.email_service_name}/domains/${var.domain_name}"

  properties = merge(
    { domainManagement = var.domain_management },
    var.user_engagement_tracking != null ? { userEngagementTracking = var.user_engagement_tracking } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "email_communication_service_domain" {
  path            = local.domain_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.fromSenderDomain",
    "properties.mailFromSenderDomain",
    "properties.verificationStates",
    "properties.verificationRecords",
  ])

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Accepted", "Creating", "Updating", "Running"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Accepted", "Creating", "Updating", "Running"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = "404"
      pending = ["202", "200"]
    }
  }
}
