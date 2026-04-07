# Source: azure-rest-api-specs
#   spec_path  : dnsresolver/resource-manager/Microsoft.Network/DnsResolver
#   api_version: 2025-05-01
#   operation  : DnsResolvers_CreateOrUpdate        (PUT, async — Azure-AsyncOperation header)
#   delete     : DnsResolvers_Delete                (DELETE, async)
#   inbound    : InboundEndpoints_CreateOrUpdate    (PUT, async — Azure-AsyncOperation header)

locals {
  api_version   = "2025-05-01"
  resolver_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/dnsResolvers/${var.dns_resolver_name}"

  resolver_body = merge(
    {
      location = var.location
      properties = {
        virtualNetwork = {
          id = var.virtual_network_id
        }
      }
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "dns_resolver" {
  path            = local.resolver_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.resolver_body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.dnsResolverState",
  ])

  # PUT returns 202 with Azure-AsyncOperation header; resource returns 404 until ready.
  poll_create = {
    url_locator       = "header.Azure-AsyncOperation"
    status_locator    = "body.status"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["InProgress"]
    }
  }

  poll_update = {
    url_locator       = "header.Azure-AsyncOperation"
    status_locator    = "body.status"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["InProgress"]
    }
  }

  poll_delete = {
    url_locator       = "header.Azure-AsyncOperation"
    status_locator    = "body.status"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["InProgress"]
    }
  }
}

# ── Inbound Endpoints ────────────────────────────────────────────────────────

resource "rest_resource" "inbound_endpoint" {
  for_each = { for ep in var.inbound_endpoints : ep.name => ep }

  path          = "${local.resolver_path}/inboundEndpoints/${each.key}"
  create_method = "PUT"

  query = {
    api-version = [local.api_version]
  }

  body = merge(
    {
      location = var.location
      properties = {
        ipConfigurations = [
          merge(
            {
              subnet = {
                id = each.value.subnet_id
              }
              privateIpAllocationMethod = each.value.private_ip_allocation_method
            },
            each.value.private_ip_address != null ? { privateIpAddress = each.value.private_ip_address } : {},
          )
        ]
      }
    },
    var.tags != null ? { tags = var.tags } : {},
  )

  output_attrs = toset([
    "properties.provisioningState",
    "properties.ipConfigurations",
  ])

  # PUT returns 202 with Azure-AsyncOperation header; resource returns 404 until ready.
  poll_create = {
    url_locator       = "header.Azure-AsyncOperation"
    status_locator    = "body.status"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["InProgress"]
    }
  }

  poll_update = {
    url_locator       = "header.Azure-AsyncOperation"
    status_locator    = "body.status"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["InProgress"]
    }
  }

  poll_delete = {
    url_locator       = "header.Azure-AsyncOperation"
    status_locator    = "body.status"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["InProgress"]
    }
  }

  depends_on = [rest_resource.dns_resolver]
}
