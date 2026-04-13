# Unit test — modules/azure/policy_definition
# Plan-only: validates ARM path construction and plan-time-known outputs.
# No provider_check data source — runs with a placeholder token.
# Run: terraform test -filter=tests/unit_azure_policy_definition.tftest.hcl

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

run "plan_mg_scope" {
  command = plan

  module {
    source = "./modules/azure/policy_definition"
  }

  variables {
    scope                  = "/providers/Microsoft.Management/managementGroups/mg-root"
    policy_definition_name = "deny-unapproved-regions"
    display_name           = "Deny resources outside approved regions"
    mode                   = "Indexed"
    policy_rule = {
      if = {
        not = {
          field = "location"
          in    = "[parameters('allowedLocations')]"
        }
      }
      then = { effect = "Deny" }
    }
    parameters = {
      allowedLocations = {
        type = "Array"
        metadata = {
          displayName = "Allowed locations"
        }
        defaultValue = ["westeurope", "northeurope"]
      }
    }
  }

  assert {
    condition     = output.id == "/providers/Microsoft.Management/managementGroups/mg-root/providers/Microsoft.Authorization/policyDefinitions/deny-unapproved-regions"
    error_message = "id must be the full ARM path at management group scope."
  }

  assert {
    condition     = output.name == "deny-unapproved-regions"
    error_message = "name must echo policy_definition_name."
  }

}

run "plan_subscription_scope" {
  command = plan

  module {
    source = "./modules/azure/policy_definition"
  }

  variables {
    scope                  = "/subscriptions/${var.subscription_id}"
    policy_definition_name = "require-owner-tag"
    display_name           = "Require owner tag on all resources"
    mode                   = "Indexed"
    policy_rule = {
      if   = { field = "tags['owner']", exists = "false" }
      then = { effect = "Deny" }
    }
  }

  assert {
    condition     = output.id == "/subscriptions/${var.subscription_id}/providers/Microsoft.Authorization/policyDefinitions/require-owner-tag"
    error_message = "id must be the full ARM path at subscription scope."
  }
}
