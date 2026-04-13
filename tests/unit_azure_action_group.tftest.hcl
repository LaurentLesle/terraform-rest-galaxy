# Unit test — modules/azure/action_group
# Run: terraform test -filter=tests/unit_azure_action_group.tftest.hcl

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

run "plan_action_group" {
  command = plan

  module {
    source = "./modules/azure/action_group"
  }

  variables {
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    resource_group_name = "test-rg"
    action_group_name   = "ag-test"
    short_name          = "test"
    enabled             = true
    email_receivers = [
      {
        name          = "test-email"
        email_address = "test@example.com"
      }
    ]
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/actionGroups/ag-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "ag-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.short_name == "test"
    error_message = "Short name output must echo input."
  }

  assert {
    condition     = output.enabled == true
    error_message = "Enabled output must echo input."
  }
}
