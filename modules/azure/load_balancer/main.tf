# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/loadBalancers
#   api_version: 2025-05-01
#   operation  : LoadBalancers_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : LoadBalancers_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  lb_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/loadBalancers/${var.load_balancer_name}"
  lb_id       = local.lb_path

  frontend_ip_configurations = var.frontend_ip_configurations != null ? [
    for fip in var.frontend_ip_configurations : merge(
      { name = fip.name },
      fip.zones != null ? { zones = fip.zones } : {},
      {
        properties = merge(
          fip.subnet_id != null ? { subnet = { id = fip.subnet_id } } : {},
          fip.private_ip_address != null ? { privateIPAddress = fip.private_ip_address } : {},
          fip.private_ip_allocation_method != null ? { privateIPAllocationMethod = fip.private_ip_allocation_method } : {},
          fip.public_ip_address_id != null ? { publicIPAddress = { id = fip.public_ip_address_id } } : {},
        )
      },
    )
  ] : null

  backend_address_pools = var.backend_address_pools != null ? [
    for bap in var.backend_address_pools : { name = bap.name }
  ] : null

  probes = var.probes != null ? [
    for p in var.probes : {
      name = p.name
      properties = merge(
        {
          protocol = p.protocol
          port     = p.port
        },
        p.request_path != null ? { requestPath = p.request_path } : {},
        p.interval_in_seconds != null ? { intervalInSeconds = p.interval_in_seconds } : {},
        p.number_of_probes != null ? { numberOfProbes = p.number_of_probes } : {},
      )
    }
  ] : null

  # Build name→id maps for self-referencing within the LB
  _fip_id_map = var.frontend_ip_configurations != null ? {
    for fip in var.frontend_ip_configurations : fip.name => "${local.lb_id}/frontendIPConfigurations/${fip.name}"
  } : {}

  _bap_id_map = var.backend_address_pools != null ? {
    for bap in var.backend_address_pools : bap.name => "${local.lb_id}/backendAddressPools/${bap.name}"
  } : {}

  _probe_id_map = var.probes != null ? {
    for p in var.probes : p.name => "${local.lb_id}/probes/${p.name}"
  } : {}

  load_balancing_rules = var.load_balancing_rules != null ? [
    for r in var.load_balancing_rules : {
      name = r.name
      properties = merge(
        {
          protocol                = r.protocol
          frontendPort            = r.frontend_port
          backendPort             = r.backend_port
          frontendIPConfiguration = { id = local._fip_id_map[r.frontend_ip_config_name] }
          backendAddressPool      = { id = local._bap_id_map[r.backend_address_pool_name] }
        },
        r.probe_name != null ? { probe = { id = local._probe_id_map[r.probe_name] } } : {},
        r.idle_timeout_in_minutes != null ? { idleTimeoutInMinutes = r.idle_timeout_in_minutes } : {},
        r.enable_floating_ip != null ? { enableFloatingIP = r.enable_floating_ip } : {},
        r.enable_tcp_reset != null ? { enableTcpReset = r.enable_tcp_reset } : {},
      )
    }
  ] : null

  inbound_nat_rules = var.inbound_nat_rules != null ? [
    for r in var.inbound_nat_rules : {
      name = r.name
      properties = merge(
        {
          protocol                = r.protocol
          frontendPortRangeStart  = r.frontend_port_range_start
          frontendPortRangeEnd    = r.frontend_port_range_end
          backendPort             = r.backend_port
          frontendIPConfiguration = { id = local._fip_id_map[r.frontend_ip_config_name] }
        },
        r.backend_address_pool_name != null ? { backendAddressPool = { id = local._bap_id_map[r.backend_address_pool_name] } } : {},
        r.idle_timeout_in_minutes != null ? { idleTimeoutInMinutes = r.idle_timeout_in_minutes } : {},
        r.enable_floating_ip != null ? { enableFloatingIP = r.enable_floating_ip } : {},
        r.enable_tcp_reset != null ? { enableTcpReset = r.enable_tcp_reset } : {},
      )
    }
  ] : null

  properties = merge(
    {},
    local.frontend_ip_configurations != null ? { frontendIPConfigurations = local.frontend_ip_configurations } : {},
    local.backend_address_pools != null ? { backendAddressPools = local.backend_address_pools } : {},
    local.probes != null ? { probes = local.probes } : {},
    local.load_balancing_rules != null ? { loadBalancingRules = local.load_balancing_rules } : {},
    local.inbound_nat_rules != null ? { inboundNatRules = local.inbound_nat_rules } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
      sku = merge(
        { name = var.sku_name },
        var.sku_tier != null ? { tier = var.sku_tier } : {},
      )
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "load_balancer" {
  path            = local.lb_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.frontendIPConfigurations",
    "properties.backendAddressPools",
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
