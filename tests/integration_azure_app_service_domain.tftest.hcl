# Integration test — app_service_domain (plan only)
# Run: terraform test -filter=tests/integration_azure_app_service_domain.tftest.hcl

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

run "plan_app_service_domain" {
  command = plan

  variables {
    azure_app_service_domains = {
      test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-test"
        domain_name         = "contoso.com"
        contact_admin       = { first_name = "John", last_name = "Doe", email = "admin@contoso.com", phone = "+1.5551234567" }
        contact_billing     = { first_name = "John", last_name = "Doe", email = "billing@contoso.com", phone = "+1.5551234567" }
        contact_registrant  = { first_name = "John", last_name = "Doe", email = "registrant@contoso.com", phone = "+1.5551234567" }
        contact_tech        = { first_name = "John", last_name = "Doe", email = "tech@contoso.com", phone = "+1.5551234567" }
        consent_agreed_by   = "203.0.113.10"
        consent_agreed_at   = "2026-01-01T00:00:00Z"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_app_service_domains["test"].id != null
    error_message = "Plan failed — app service domain 'test' not found."
  }
}
