# Unit test — modules/azure/management_group
# Plan-only: validates ARM path construction and plan-time-known outputs.
# No provider_check data source — runs with a placeholder token.
# Run: terraform test -filter=tests/unit_azure_management_group.tftest.hcl

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

run "plan_root_mg" {
  command = plan

  module {
    source = "./modules/azure/management_group"
  }

  variables {
    management_group_id = "mg-contoso-root"
    display_name        = "Contoso Root"
  }

  assert {
    condition     = output.id == "/providers/Microsoft.Management/managementGroups/mg-contoso-root"
    error_message = "id must be the full ARM path for a tenant-root MG."
  }

  assert {
    condition     = output.name == "mg-contoso-root"
    error_message = "name must echo management_group_id."
  }

}

run "plan_child_mg" {
  command = plan

  module {
    source = "./modules/azure/management_group"
  }

  variables {
    management_group_id = "mg-platform"
    display_name        = "Platform"
    parent_id           = "/providers/Microsoft.Management/managementGroups/mg-contoso-root"
  }

  assert {
    condition     = output.id == "/providers/Microsoft.Management/managementGroups/mg-platform"
    error_message = "id must be the full ARM path for the child MG."
  }

  assert {
    condition     = output.name == "mg-platform"
    error_message = "name must echo management_group_id."
  }

}
