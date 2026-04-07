# Unit test — modules/azure/dns_zone
# Tests the sub-module in isolation (plan only). No provider_check data source,
# so plan completes with a placeholder token.
# Run: terraform test -filter=tests/unit_azure_dns_zone.tftest.hcl

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = var.access_token
      }
    }
  }
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_dns_zone" {
  command = plan

  module {
    source = "./modules/azure/dns_zone"
  }

  variables {
    subscription_id     = var.subscription_id
    resource_group_name = "rg-test"
    zone_name           = "contoso.com"
    location            = "global"
    zone_type           = "Public"
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/rg-test/providers/Microsoft.Network/dnsZones/contoso.com"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "contoso.com"
    error_message = "name output must echo input."
  }

  assert {
    condition     = output.location == "global"
    error_message = "location output must echo input."
  }
}
