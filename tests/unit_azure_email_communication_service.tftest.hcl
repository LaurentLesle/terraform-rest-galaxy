# Unit test — modules/azure/email_communication_service
# Tests the sub-module in isolation (plan only).
# Run: terraform test -filter=tests/unit_azure_email_communication_service.tftest.hcl

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = var.access_token
      }
    }
  }
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_email_communication_service" {
  command = plan

  module {
    source = "./modules/azure/email_communication_service"
  }

  variables {
    subscription_id     = var.subscription_id
    resource_group_name = "rg-test"
    email_service_name  = "test-email-svc"
    location            = "global"
    data_location       = "Europe"
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/rg-test/providers/Microsoft.Communication/emailServices/test-email-svc"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "test-email-svc"
    error_message = "name output must echo input."
  }

  assert {
    condition     = output.location == "global"
    error_message = "location output must echo input."
  }

  assert {
    condition     = output.data_location == "Europe"
    error_message = "data_location output must echo input."
  }
}
