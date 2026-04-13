# Source: azure-rest-api-specs
#   spec_path : communication/resource-manager/Microsoft.Communication
#   api_version: 2026-03-18
#   operation  : EmailServices_CreateOrUpdate  (PUT, async — azure-async-operation)
#   delete     : EmailServices_Delete          (DELETE, async — location)

locals {
  api_version = "2026-03-18"
  ecs_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Communication/emailServices/${var.email_service_name}"

  body = merge(
    {
      location = var.location
      properties = {
        dataLocation = var.data_location
      }
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Resource provider registration check ─────────────────────────────────────

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Communication"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "email_communication_service" {
  path            = local.ecs_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.dataLocation",
  ])

  lifecycle {
    precondition {
      condition     = contains(["Registered", "Registering"], data.rest_resource.provider_check.output.registrationState)
      error_message = "Resource provider Microsoft.Communication is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    communication:\n      resource_provider_namespace: Microsoft.Communication"
    }
  }

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = ["Succeeded"]
      pending = ["Accepted", "Creating", "Updating", "Running"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = ["Succeeded"]
      pending = ["Accepted", "Creating", "Updating", "Running"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = ["404"]
      pending = ["202", "200"]
    }
  }
}
