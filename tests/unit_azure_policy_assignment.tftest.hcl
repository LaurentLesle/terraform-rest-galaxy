# Unit test — modules/azure/policy_assignment
# Plan-only: validates ARM path construction and plan-time-known outputs.
# No provider_check data source — runs with a placeholder token.
# Run: terraform test -filter=tests/unit_azure_policy_assignment.tftest.hcl

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

run "plan_mg_scope_builtin" {
  command = plan

  module {
    source = "./modules/azure/policy_assignment"
  }

  variables {
    scope                = "/providers/Microsoft.Management/managementGroups/mg-root"
    assignment_name      = "lz-cis-benchmark"
    display_name         = "CIS Microsoft Azure Foundations Benchmark v2.0.0"
    policy_definition_id = "/providers/Microsoft.Authorization/policySetDefinitions/06f19060-9e68-4070-92ca-f15cc126059e"
    enforcement_mode     = "DoNotEnforce"
  }

  assert {
    condition     = output.id == "/providers/Microsoft.Management/managementGroups/mg-root/providers/Microsoft.Authorization/policyAssignments/lz-cis-benchmark"
    error_message = "id must be the full ARM path at management group scope."
  }

  assert {
    condition     = output.name == "lz-cis-benchmark"
    error_message = "name must echo assignment_name."
  }

}

run "plan_subscription_scope_with_parameters" {
  command = plan

  module {
    source = "./modules/azure/policy_assignment"
  }

  variables {
    scope                = "/subscriptions/${var.subscription_id}"
    assignment_name      = "allowed-locations"
    display_name         = "Allowed locations"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/e56962a6-4747-49cd-b67b-bf8b01975c4c"
    enforcement_mode     = "Default"
    parameters = {
      listOfAllowedLocations = { value = ["westeurope", "northeurope"] }
    }
    non_compliance_messages = [
      { message = "Resources must be deployed in westeurope or northeurope." }
    ]
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/providers/Microsoft.Authorization/policyAssignments/allowed-locations"
    error_message = "id must be the full ARM path at subscription scope."
  }
}

run "plan_system_assigned_identity" {
  command = plan

  module {
    source = "./modules/azure/policy_assignment"
  }

  variables {
    scope                = "/providers/Microsoft.Management/managementGroups/mg-root"
    assignment_name      = "configure-ama-linux"
    display_name         = "Configure AMA on Linux VMs"
    policy_definition_id = "/providers/Microsoft.Authorization/policyDefinitions/a4034bc6-ae50-406d-bf76-50f4ee5a7811"
    enforcement_mode     = "Default"
    identity_type        = "SystemAssigned"
    location             = "westeurope"
  }

  assert {
    condition     = output.id == "/providers/Microsoft.Management/managementGroups/mg-root/providers/Microsoft.Authorization/policyAssignments/configure-ama-linux"
    error_message = "id must be the full ARM path."
  }

}
