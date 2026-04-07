# Source: azure-rest-api-specs
#   spec_path  : containerregistry/resource-manager/Microsoft.ContainerRegistry/Registry
#   api_version: 2025-11-01
#   operation  : Registries_Create  (PUT, async — azure-async-operation polling)
#   delete     : Registries_Delete  (DELETE, async — location polling)

locals {
  api_version = "2025-11-01"
  acr_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ContainerRegistry/registries/${var.registry_name}"

  properties = merge(
    { adminUserEnabled = var.admin_user_enabled },
    var.public_network_access != null ? { publicNetworkAccess = var.public_network_access } : {},
    var.anonymous_pull_enabled != null ? { anonymousPullEnabled = var.anonymous_pull_enabled } : {},
  )

  body = merge(
    {
      sku        = { name = var.sku_name }
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.ContainerRegistry"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

# ── Name availability pre-check ──────────────────────────────────────────────
resource "rest_operation" "check_name_availability" {
  count  = var.check_existance ? 0 : 1
  path   = "/subscriptions/${var.subscription_id}/providers/Microsoft.ContainerRegistry/checkNameAvailability"
  method = "POST"

  query = {
    api-version = [local.api_version]
  }

  body = {
    name = var.registry_name
    type = "Microsoft.ContainerRegistry/registries"
  }

  output_attrs = toset(["nameAvailable", "reason", "message"])
}

resource "rest_resource" "container_registry" {
  path            = local.acr_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.loginServer",
    "properties.creationDate",
    "type",
  ])

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.ContainerRegistry is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    containerregistry:\n      resource_provider_namespace: Microsoft.ContainerRegistry"
    }
    precondition {
      condition     = var.check_existance || rest_operation.check_name_availability[0].output.nameAvailable
      error_message = "Container registry name '${var.registry_name}' is not available: ${try(rest_operation.check_name_availability[0].output.message, "unknown reason")}. Choose a different registry_name."
    }
  }

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 5
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 5
    status = {
      success = "Succeeded"
      pending = ["Updating"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 5
    status = {
      success = "404"
      pending = ["200", "202"]
    }
  }
}
