# Unit test — modules/azure/policy_set_definition
# Plan-only: validates ARM path construction and plan-time-known outputs.
# No provider_check data source — runs with a placeholder token.
# Run: terraform test -filter=tests/unit_azure_policy_set_definition.tftest.hcl

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

run "plan_mg_scope_minimum" {
  command = plan

  module {
    source = "./modules/azure/policy_set_definition"
  }

  variables {
    scope                      = "/providers/Microsoft.Management/managementGroups/mg-root"
    policy_set_definition_name = "lz-tagging-baseline"
    display_name               = "Landing Zone Tagging Baseline"
    policy_definitions = [
      {
        policy_definition_id           = "/providers/Microsoft.Authorization/policyDefinitions/871b6d14-10aa-478d-b590-94f262ecfa99"
        policy_definition_reference_id = "require_tags"
      }
    ]
  }

  assert {
    condition     = output.id == "/providers/Microsoft.Management/managementGroups/mg-root/providers/Microsoft.Authorization/policySetDefinitions/lz-tagging-baseline"
    error_message = "id must be the full ARM path at management group scope."
  }

  assert {
    condition     = output.name == "lz-tagging-baseline"
    error_message = "name must echo policy_set_definition_name."
  }

}

run "plan_mg_scope_with_parameters_and_groups" {
  command = plan

  module {
    source = "./modules/azure/policy_set_definition"
  }

  variables {
    scope                      = "/providers/Microsoft.Management/managementGroups/mg-root"
    policy_set_definition_name = "lz-network-baseline"
    display_name               = "Landing Zone Network Security Baseline"
    description                = "Network security guardrails for all landing zone subscriptions."
    metadata = {
      category = "Network"
      version  = "1.0.0"
    }
    policy_definition_groups = [
      {
        name         = "network-controls"
        display_name = "Network Controls"
      }
    ]
    policy_definitions = [
      {
        policy_definition_id           = "/providers/Microsoft.Authorization/policyDefinitions/83a86a26-fd1f-447c-b59d-e51f44264114"
        policy_definition_reference_id = "deny_public_ip"
        group_names                    = ["network-controls"]
      },
      {
        policy_definition_id           = "/providers/Microsoft.Authorization/policyDefinitions/b2982f36-99f2-4db5-8eff-283140c09693"
        policy_definition_reference_id = "deny_public_network_storage"
        group_names                    = ["network-controls"]
        parameters = {
          effect = { value = "Deny" }
        }
      }
    ]
  }

  assert {
    condition     = output.id == "/providers/Microsoft.Management/managementGroups/mg-root/providers/Microsoft.Authorization/policySetDefinitions/lz-network-baseline"
    error_message = "id must be the full ARM path at management group scope."
  }

}
