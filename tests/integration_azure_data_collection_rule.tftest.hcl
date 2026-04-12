# Integration test — data_collection_rule (plan only)
# Run: terraform test -filter=tests/integration_azure_data_collection_rule.tftest.hcl
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

run "plan_data_collection_rule" {
  command = plan

  variables {
    azure_data_collection_rules = {
      test = {
        subscription_id           = var.subscription_id
        resource_group_name       = "rg-test"
        data_collection_rule_name = "dcr-test"
        location                  = "westeurope"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["test"].id != null
    error_message = "Plan failed — data collection rule 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rules["test"].name == "dcr-test"
    error_message = "Plan failed — data collection rule name must be 'dcr-test'."
  }
}
