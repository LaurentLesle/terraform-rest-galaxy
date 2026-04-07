# Integration test — azure_billing_associated_tenants (root module)
# Run: terraform test -filter=tests/integration_azure_billing_associated_tenant.tftest.hcl

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

run "plan_billing_associated_tenant" {
  command = plan

  variables {
    subscription_id = var.subscription_id

    azure_billing_associated_tenants = {
      test = {
        billing_account_name          = "12345678:12345678-1234-1234-1234-123456789012_2024-01-01"
        tenant_id                     = "aaaabbbb-cccc-dddd-eeee-ffffffffffff"
        display_name                  = "Test Partner"
        billing_management_state      = "Active"
        provisioning_management_state = "NotRequested"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_billing_associated_tenants["test"] != null
    error_message = "Plan failed — billing associated tenant 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_billing_associated_tenants["test"].tenant_id == "aaaabbbb-cccc-dddd-eeee-ffffffffffff"
    error_message = "Tenant ID must echo input."
  }
}
