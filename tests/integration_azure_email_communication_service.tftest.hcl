# Integration test — email_communication_service (plan only)
# Run: terraform test -filter=tests/integration_azure_email_communication_service.tftest.hcl

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

run "plan_email_communication_service" {
  command = plan

  variables {
    azure_email_communication_services = {
      test = {
        subscription_id     = var.subscription_id
        resource_group_name = "rg-test"
        email_service_name  = "test-email-svc"
        location            = "global"
        data_location       = "Europe"
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_email_communication_services["test"].id != null
    error_message = "Plan failed — email communication service 'test' not found."
  }
}
