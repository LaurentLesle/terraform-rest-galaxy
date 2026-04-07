# Unit test — modules/azure/app_service_domain
# Tests the sub-module in isolation (plan only).
# NOTE: This module has a provider_check data source for Microsoft.DomainRegistration
# and a check_domain_availability operation, so plan will fail with a placeholder token
# (same as unit_azure_network_manager). The test is kept for structure completeness.
# Run: terraform test -filter=tests/unit_azure_app_service_domain.tftest.hcl

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

run "plan_app_service_domain" {
  command = plan

  module {
    source = "./modules/azure/app_service_domain"
  }

  variables {
    subscription_id     = var.subscription_id
    resource_group_name = "rg-test"
    domain_name         = "contoso.com"
    location            = "global"
    contact_admin       = { first_name = "John", last_name = "Doe", email = "admin@contoso.com", phone = "+1.5551234567", address_line1 = "1 Microsoft Way", city = "Redmond", state = "WA", country = "US", postal_code = "98052" }
    contact_billing     = { first_name = "John", last_name = "Doe", email = "billing@contoso.com", phone = "+1.5551234567", address_line1 = "1 Microsoft Way", city = "Redmond", state = "WA", country = "US", postal_code = "98052" }
    contact_registrant  = { first_name = "John", last_name = "Doe", email = "registrant@contoso.com", phone = "+1.5551234567", address_line1 = "1 Microsoft Way", city = "Redmond", state = "WA", country = "US", postal_code = "98052" }
    contact_tech        = { first_name = "John", last_name = "Doe", email = "tech@contoso.com", phone = "+1.5551234567", address_line1 = "1 Microsoft Way", city = "Redmond", state = "WA", country = "US", postal_code = "98052" }
    consent_agreed_by   = "203.0.113.10"
    consent_agreed_at   = "2026-01-01T00:00:00Z"
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/rg-test/providers/Microsoft.DomainRegistration/domains/contoso.com"
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
