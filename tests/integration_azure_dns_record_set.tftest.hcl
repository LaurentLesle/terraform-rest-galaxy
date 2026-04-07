# Integration test — dns_record_set (plan only)
# Run: terraform test -filter=tests/integration_azure_dns_record_set.tftest.hcl

# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "graph_access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_dns_record_set" {
  command = plan

  variables {
    azure_dns_record_sets = {
      test_txt = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-test"
        zone_name           = "contoso.com"
        record_name         = "@"
        record_type         = "TXT"
        ttl                 = 3600
        txt_records         = [{ value = ["v=spf1 include:spf.protection.outlook.com -all"] }]
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_dns_record_sets["test_txt"].id != null
    error_message = "Plan failed — DNS record set 'test_txt' not found."
  }
}
