# Source: azure-rest-api-specs
#   spec_path : network/resource-manager/Microsoft.Network/firewallPolicies
#   api_version: 2025-05-01
#   operation  : FirewallPolicies_CreateOrUpdate  (PUT, async — provisioningState polling)
#   delete     : FirewallPolicies_Delete          (DELETE, async)

locals {
  api_version = "2025-05-01"
  fp_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Network/firewallPolicies/${var.firewall_policy_name}"

  dns_settings = var.dns_servers != null || var.dns_proxy_enabled != null ? merge(
    var.dns_servers != null ? { servers = var.dns_servers } : {},
    var.dns_proxy_enabled != null ? { enableProxy = var.dns_proxy_enabled } : {},
  ) : null

  explicit_proxy = var.explicit_proxy != null ? merge(
    { enableExplicitProxy = var.explicit_proxy.enable_explicit_proxy },
    var.explicit_proxy.http_port != null ? { httpPort = var.explicit_proxy.http_port } : {},
    var.explicit_proxy.https_port != null ? { httpsPort = var.explicit_proxy.https_port } : {},
    var.explicit_proxy.enable_pac_file != null ? { enablePacFile = var.explicit_proxy.enable_pac_file } : {},
    var.explicit_proxy.pac_file_port != null ? { pacFilePort = var.explicit_proxy.pac_file_port } : {},
    var.explicit_proxy.pac_file_sas_url != null ? { pacFile = var.explicit_proxy.pac_file_sas_url } : {},
  ) : null

  properties = merge(
    {
      sku = { tier = var.sku_tier }
    },
    var.base_policy_id != null ? { basePolicy = { id = var.base_policy_id } } : {},
    var.threat_intel_mode != null ? { threatIntelMode = var.threat_intel_mode } : {},
    local.dns_settings != null ? { dnsSettings = local.dns_settings } : {},
    local.explicit_proxy != null ? { explicitProxy = local.explicit_proxy } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_resource" "firewall_policy" {
  path            = local.fp_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
  ])

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Updating", "Provisioning"]
    }
  }

  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = "404"
      pending = ["200", "202"]
    }
  }
}
