# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/networkInterfaces
#   api_version: 2025-05-01
#   operation  : NetworkInterfaces_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : NetworkInterfaces_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  nic_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/networkInterfaces/${var.network_interface_name}"

  ip_configurations = [
    for ipc in var.ip_configurations : {
      name = ipc.name
      properties = merge(
        {},
        ipc.subnet_id != null ? { subnet = { id = ipc.subnet_id } } : {},
        ipc.private_ip_address != null ? { privateIPAddress = ipc.private_ip_address } : {},
        ipc.private_ip_allocation_method != null ? { privateIPAllocationMethod = ipc.private_ip_allocation_method } : {},
        ipc.private_ip_address_version != null ? { privateIPAddressVersion = ipc.private_ip_address_version } : {},
        ipc.primary != null ? { primary = ipc.primary } : {},
      )
    }
  ]

  properties = merge(
    {
      ipConfigurations = local.ip_configurations
    },
    var.enable_accelerated_networking != null ? { enableAcceleratedNetworking = var.enable_accelerated_networking } : {},
    var.enable_ip_forwarding != null ? { enableIPForwarding = var.enable_ip_forwarding } : {},
    var.dns_servers != null ? { dnsSettings = { dnsServers = var.dns_servers } } : {},
    var.network_security_group_id != null ? { networkSecurityGroup = { id = var.network_security_group_id } } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "network_interface" {
  path            = local.nic_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.macAddress",
    "properties.ipConfigurations",
  ])

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning", "Creating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning"]
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
