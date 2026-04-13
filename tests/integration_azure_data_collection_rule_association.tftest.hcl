# Integration test — data_collection_rule_association (plan only)
# Run: terraform test -filter=tests/integration_azure_data_collection_rule_association.tftest.hcl
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

run "plan_data_collection_rule_association" {
  command = plan

  variables {
    azure_data_collection_rule_associations = {
      test = {
        subscription_id         = "00000000-0000-0000-0000-000000000000"
        resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Compute/virtualMachines/vm-test"
        association_name        = "dcra-test"
        data_collection_rule_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Insights/dataCollectionRules/dcr-test"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rule_associations["test"].id != null
    error_message = "Plan failed — data collection rule association 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_rule_associations["test"].name == "dcra-test"
    error_message = "Plan failed — association name must be 'dcra-test'."
  }
}
