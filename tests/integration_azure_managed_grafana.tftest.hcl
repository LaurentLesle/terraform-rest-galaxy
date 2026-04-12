# Integration test — managed_grafana (plan only)
# Run: terraform test -filter=tests/integration_azure_managed_grafana.tftest.hcl
#
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

run "plan_managed_grafana" {
  command = plan

  variables {
    azure_managed_grafanas = {
      test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-test"
        grafana_name        = "grafana-test"
        location            = "westeurope"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_managed_grafanas["test"].id != null
    error_message = "Plan failed — managed grafana 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_managed_grafanas["test"].name == "grafana-test"
    error_message = "Plan failed — managed grafana name must be 'grafana-test'."
  }
}
