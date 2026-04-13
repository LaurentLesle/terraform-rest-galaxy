# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   swagger_file: privateLinkScopes_API.json
#   api_version: 2021-09-01
#   stability  : stable
#   operation  : PrivateLinkScopedResources_CreateOrUpdate (PUT, long-running — no async header)
#   delete     : PrivateLinkScopedResources_Delete (DELETE, long-running — no async header)
#
# This resource links an Azure Monitor resource (Log Analytics Workspace,
# Data Collection Endpoint, Azure Monitor Workspace) into a Private Link Scope.
# Full CRUD lifecycle (PUT/GET/DELETE) confirmed in spec — use rest_resource.

locals {
  api_version          = "2021-09-01"
  scoped_resource_path = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/privateLinkScopes/${var.private_link_scope_name}/scopedResources/${var.scoped_resource_name}"

  body = {
    properties = {
      linkedResourceId = var.linked_resource_id
    }
  }
}

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Insights"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "monitor_private_link_scoped_resource" {
  path            = local.scoped_resource_path
  create_method   = "PUT"
  check_existance = var.check_existance

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Insights is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    insights:\n      resource_provider_namespace: Microsoft.Insights"
    }
  }


  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
  ])

  # PUT is long-running — polls provisioningState.
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = ["Succeeded"]
      pending = ["Creating", "Provisioning", "Updating", "Accepted"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Provisioning", "Accepted"]
    }
  }

  # DELETE is long-running — polls until 404.
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = ["404"]
      pending = ["202", "200"]
    }
  }

  # linked_resource_id is effectively immutable once created — changing it
  # would require removing and re-adding the scoped resource association.
  force_new_attrs = toset([
    "properties.linkedResourceId",
  ])
}
