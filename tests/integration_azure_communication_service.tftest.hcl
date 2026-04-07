# Integration test — communication_service (plan only)
# Run: terraform test -filter=tests/integration_azure_communication_service.tftest.hcl

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

run "plan_communication_service" {
  command = plan

  variables {
    azure_communication_services = {
      test = {
        subscription_id            = var.subscription_id
        resource_group_name        = "rg-test"
        communication_service_name = "test-acs-main"
        location                   = "global"
        data_location              = "Europe"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_communication_services["test"].id != null
    error_message = "Plan failed — communication service 'test' not found."
  }
}
