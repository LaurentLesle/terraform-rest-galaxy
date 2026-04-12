# Integration test — data_collection_endpoint (plan only)
# Run: terraform test -filter=tests/integration_azure_data_collection_endpoint.tftest.hcl
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

run "plan_data_collection_endpoint" {
  command = plan

  variables {
    azure_data_collection_endpoints = {
      test = {
        subscription_id               = var.subscription_id
        resource_group_name           = "rg-test"
        data_collection_endpoint_name = "dce-test"
        location                      = "westeurope"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["test"].id != null
    error_message = "Plan failed — data collection endpoint 'test' not found in output."
  }

  assert {
    condition     = output.azure_values.azure_data_collection_endpoints["test"].name == "dce-test"
    error_message = "Plan failed — data collection endpoint name must be 'dce-test'."
  }
}
