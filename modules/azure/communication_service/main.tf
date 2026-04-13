# Source: azure-rest-api-specs
#   spec_path : communication/resource-manager/Microsoft.Communication
#   api_version: 2026-03-18
#   operation  : CommunicationServices_CreateOrUpdate  (PUT, async — azure-async-operation)
#   delete     : CommunicationServices_Delete          (DELETE, async — location)

locals {
  api_version = "2026-03-18"
  acs_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Communication/communicationServices/${var.communication_service_name}"

  properties = merge(
    { dataLocation = var.data_location },
    var.linked_domains != null ? { linkedDomains = var.linked_domains } : {},
    var.public_network_access != null ? { publicNetworkAccess = var.public_network_access } : {},
    var.disable_local_auth != null ? { disableLocalAuth = var.disable_local_auth } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
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

# ── Name availability pre-check ──────────────────────────────────────────────

resource "rest_operation" "check_name_availability" {
  count  = var.check_existance ? 0 : 1
  path   = "/subscriptions/${var.subscription_id}/providers/Microsoft.Communication/checkNameAvailability"
  method = "POST"

  query = {
    api-version = [local.api_version]
  }

  body = {
    name = var.communication_service_name
    type = "Microsoft.Communication/communicationServices"
  }

  output_attrs = toset(["nameAvailable", "reason", "message"])
}

resource "rest_resource" "communication_service" {
  path            = local.acs_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.hostName",
    "properties.immutableResourceId",
  ])

  lifecycle {
    precondition {
      condition     = contains(["Registered", "Registering"], data.rest_resource.provider_check.output.registrationState)
      error_message = "Resource provider Microsoft.Communication is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    communication:\n      resource_provider_namespace: Microsoft.Communication"
    }
    precondition {
      condition     = var.check_existance || rest_operation.check_name_availability[0].output.nameAvailable
      error_message = "Communication Service name '${var.communication_service_name}' is not available: ${try(rest_operation.check_name_availability[0].output.message, "unknown reason")}. Choose a different communication_service_name."
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
