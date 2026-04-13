# Unit test — modules/azure/data_collection_rule_association
# Run: terraform test -filter=tests/unit_azure_data_collection_rule_association.tftest.hcl

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

run "plan_data_collection_rule_association" {
  command = plan

  module {
    source = "./modules/azure/data_collection_rule_association"
  }

  variables {
    subscription_id         = "00000000-0000-0000-0000-000000000000"
    resource_id             = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Compute/virtualMachines/vm-test"
    association_name        = "dcra-test"
    data_collection_rule_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Insights/dataCollectionRules/dcr-test"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Compute/virtualMachines/vm-test/providers/Microsoft.Insights/dataCollectionRuleAssociations/dcra-test"
    error_message = "ARM ID must be correctly formed with scope-based path."
  }

  assert {
    condition     = output.name == "dcra-test"
    error_message = "Name output must echo input."
  }
}
