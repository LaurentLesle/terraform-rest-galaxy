# Unit test — modules/azure/email_communication_service_domain
# Tests the sub-module in isolation (plan only).
# Run: terraform test -filter=tests/unit_azure_email_communication_service_domain.tftest.hcl

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_email_communication_service_domain" {
  command = plan

  module {
    source = "./modules/azure/email_communication_service_domain"
  }

  variables {
    subscription_id     = var.subscription_id
    resource_group_name = "rg-test"
    email_service_name  = "test-email-svc"
    domain_name         = "AzureManagedDomain"
    location            = "global"
    domain_management   = "AzureManaged"
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/resourceGroups/rg-test/providers/Microsoft.Communication/emailServices/test-email-svc/domains/AzureManagedDomain"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "AzureManagedDomain"
    error_message = "name output must echo input."
  }

  assert {
    condition     = output.email_service_name == "test-email-svc"
    error_message = "email_service_name output must echo input."
  }

  assert {
    condition     = output.domain_management == "AzureManaged"
    error_message = "domain_management output must echo input."
  }
}
