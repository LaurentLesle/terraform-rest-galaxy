# Integration test — configurations/billing_associated_tenant.yaml
# Run: terraform test -filter=tests/integration_config_billing_associated_tenant.tftest.hcl

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
    config_file     = "configurations/billing_associated_tenant.yaml"
    subscription_id = var.subscription_id
  }

  assert {
    condition     = output.azure_values.azure_billing_associated_tenants["partner"] != null
    error_message = "Plan failed — billing associated tenant 'partner' not found."
  }
}
