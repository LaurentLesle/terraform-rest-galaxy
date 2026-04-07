# Integration test — dns_zone (plan only)
# Run: terraform test -filter=tests/integration_azure_dns_zone.tftest.hcl

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

run "plan_dns_zone" {
  command = plan

  variables {
    azure_dns_zones = {
      test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-test"
        zone_name           = "contoso.com"
        location            = "global"
        zone_type           = "Public"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_dns_zones["test"].id != null
    error_message = "Plan failed — DNS zone 'test' not found."
  }
}
