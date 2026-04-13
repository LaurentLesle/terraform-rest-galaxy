# Unit test — modules/azure/data_collection_rule
# Run: terraform test -filter=tests/unit_azure_data_collection_rule.tftest.hcl

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

run "plan_data_collection_rule" {
  command = plan

  module {
    source = "./modules/azure/data_collection_rule"
  }

  variables {
    subscription_id           = "00000000-0000-0000-0000-000000000000"
    resource_group_name       = "test-rg"
    data_collection_rule_name = "dcr-test"
    location                  = "westeurope"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/dataCollectionRules/dcr-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "dcr-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
