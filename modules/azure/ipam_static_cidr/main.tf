# Source: azure-rest-api-specs
#   spec_path  : network/resource-manager/Microsoft.Network/networkManagers/ipamPools/staticCidrs
#   api_version: 2025-05-01
#   operation  : StaticCidrs_Create  (PUT, synchronous)
#   delete     : StaticCidrs_Delete  (DELETE, synchronous)

locals {
  api_version      = "2025-05-01"
  static_cidr_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkManagers/${var.network_manager_name}/ipamPools/${var.pool_name}/staticCidrs/${var.static_cidr_name}"

  properties = merge(
    var.address_prefixes != null ? { addressPrefixes = var.address_prefixes } : {},
    var.number_of_ip_addresses_to_allocate != null ? { numberOfIPAddressesToAllocate = var.number_of_ip_addresses_to_allocate } : {},
    var.description != null ? { description = var.description } : {},
  )

  body = {
    properties = local.properties
  }
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Network"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "ipam_static_cidr" {
  path            = local.static_cidr_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.totalNumberOfIPAddresses",
  ])

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Network is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    network:\n      resource_provider_namespace: Microsoft.Network"
    }
  }
}
