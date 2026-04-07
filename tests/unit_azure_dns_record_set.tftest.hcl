# Unit test — modules/azure/dns_record_set
# Tests the sub-module in isolation (plan only). No provider_check or data sources.
# Run: terraform test -filter=tests/unit_azure_dns_record_set.tftest.hcl

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_dns_record_set_txt" {
  command = plan

  module {
    source = "./modules/azure/dns_record_set"
  }

  variables {
    subscription_id     = var.subscription_id
    resource_group_name = "rg-test"
    zone_name           = "contoso.com"
    record_name         = "@"
    record_type         = "TXT"
    ttl                 = 3600
    txt_records         = [{ value = ["v=spf1 include:spf.protection.outlook.com -all"] }]
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/rg-test/providers/Microsoft.Network/dnsZones/contoso.com/TXT/@"
    error_message = "ARM ID must be correctly formed for TXT record."
  }

  assert {
    condition     = output.record_name == "@"
    error_message = "record_name output must echo input."
  }

  assert {
    condition     = output.record_type == "TXT"
    error_message = "record_type output must echo input."
  }
}

run "plan_dns_record_set_cname" {
  command = plan

  module {
    source = "./modules/azure/dns_record_set"
  }

  variables {
    subscription_id     = var.subscription_id
    resource_group_name = "rg-test"
    zone_name           = "contoso.com"
    record_name         = "selector1._domainkey"
    record_type         = "CNAME"
    ttl                 = 3600
    cname_record        = { cname = "selector1-contoso-com._domainkey.azurecomm.net" }
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/rg-test/providers/Microsoft.Network/dnsZones/contoso.com/CNAME/selector1._domainkey"
    error_message = "ARM ID must be correctly formed for CNAME record."
  }

  assert {
    condition     = output.record_type == "CNAME"
    error_message = "record_type output must echo CNAME."
  }
}
