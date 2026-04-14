# Source: azure-rest-api-specs
#   spec_path  : github-network/resource-manager/GitHub.Network
#   api_version: 2024-04-02
#   operation  : NetworkSettings_Create  (PUT, synchronous)
#   delete     : NetworkSettings_Delete  (DELETE, synchronous)

locals {
  api_version = "2024-04-02"
  ns_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/GitHub.Network/networkSettings/${var.network_settings_name}"

  body = merge(
    {
      location = var.location
      properties = {
        subnetId   = var.subnet_id
        businessId = var.business_id
      }
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/GitHub.Network"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "github_network_settings" {
  path            = local.ns_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.subnetId",
    "properties.businessId",
  ])

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider GitHub.Network is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    github_network:\n      resource_provider_namespace: GitHub.Network"
    }
  }

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = ["Succeeded"]
      pending = ["Accepted"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = ["404"]
      pending = ["200", "202"]
    }
  }
}
