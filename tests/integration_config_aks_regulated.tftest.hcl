# Plan-only test for configurations/aks_regulated/config.yaml
# Run: terraform test -filter=tests/integration_config_aks_regulated.tftest.hcl
#
# Validates the AKS regulated configuration YAML.
# Checks that all ref: expressions resolve (including remote_states) and the plan succeeds.

# IMPORTANT: Do NOT add a provider "rest" block here.
# The root module's provider config flows through automatically.

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "graph_access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

variable "subscription_id" {
  type    = string
  default = "00000000-0000-0000-0000-000000000000"
}

run "plan_aks_regulated" {
  command = plan

  variables {
    config_file     = "configurations/aks_regulated/config.yaml"
    subscription_id = var.subscription_id
    remote_states = {
      launchpad = {
        azure_values = {
          azure_resource_groups = {
            launchpad = {
              resource_group_name = "rg-launchpad"
            }
          }
          azure_virtual_networks = {
            hub = {
              id                   = "/subscriptions/${var.subscription_id}/resourceGroups/rg-launchpad/providers/Microsoft.Network/virtualNetworks/vnet-hub-launchpad"
              name                 = "vnet-hub-launchpad"
              virtual_network_name = "vnet-hub-launchpad"
            }
          }
        }
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["aks_regulated"] != null
    error_message = "Plan failed — resource group 'aks_regulated' not found."
  }

  assert {
    condition     = output.azure_values.azure_managed_clusters["aks_regulated"] != null
    error_message = "Plan failed — managed cluster 'aks_regulated' not found."
  }

  assert {
    condition     = output.azure_values.azure_postgresql_flexible_servers["app_db"] != null
    error_message = "Plan failed — PostgreSQL flexible server 'app_db' not found."
  }

  assert {
    condition     = output.azure_values.azure_virtual_network_peerings["spoke_to_hub"] != null
    error_message = "Plan failed — VNet peering 'spoke_to_hub' not found."
  }

  assert {
    condition     = output.azure_values.azure_virtual_network_peerings["hub_to_spoke"] != null
    error_message = "Plan failed — VNet peering 'hub_to_spoke' not found."
  }

  assert {
    condition     = output.azure_values.azure_postgresql_flexible_server_administrators["aks_cp_admin"] != null
    error_message = "Plan failed — PostgreSQL Entra administrator 'aks_cp_admin' not found."
  }
}
