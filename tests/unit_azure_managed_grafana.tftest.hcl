# Unit test — modules/azure/managed_grafana
# Run: terraform test -filter=tests/unit_azure_managed_grafana.tftest.hcl

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

run "plan_managed_grafana" {
  command = plan

  module {
    source = "./modules/azure/managed_grafana"
  }

  variables {
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    resource_group_name = "test-rg"
    grafana_name        = "grafana-test"
    location            = "westeurope"
  }

  assert {
    condition     = output.id == "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/test-rg/providers/Microsoft.Dashboard/grafana/grafana-test"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "grafana-test"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.location == "westeurope"
    error_message = "Location output must echo input."
  }
}
