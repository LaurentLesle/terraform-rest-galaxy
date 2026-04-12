# Integration test — action_group (plan only)
# Run: terraform test -filter=tests/integration_azure_action_group.tftest.hcl
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

run "plan_action_group" {
  command = plan

  variables {
    azure_action_groups = {
      test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-test"
        action_group_name   = "ag-test"
        short_name          = "test"
        enabled             = true
        email_receivers = [
          {
            name                    = "test-email"
            email_address           = "test@example.com"
            use_common_alert_schema = true
          }
        ]
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_action_groups["test"].id != null
    error_message = "Plan failed — action group 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["test"].name == "ag-test"
    error_message = "Plan failed — action group name must be 'ag-test'."
  }

  assert {
    condition     = output.azure_values.azure_action_groups["test"].enabled == true
    error_message = "Plan failed — action group 'test' must be enabled."
  }
}
