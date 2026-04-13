# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights
#   swagger_file: privateLinkScopes_API.json
#   api_version: 2021-09-01
#   stability  : stable
#   operation  : PrivateLinkScopes_CreateOrUpdate (PUT, synchronous)
#   delete     : PrivateLinkScopes_Delete (DELETE, long-running — no async header, polls 404)
#
# Security note: ingestion_access_mode and query_access_mode default to
# 'PrivateOnly' for SOC2/regulated-industry compliance. Override to 'Open'
# only if the workload explicitly requires public ingestion or query access.

locals {
  api_version = "2021-09-01"
  _scope_name = var.scope_name != null ? var.scope_name : "ampls"
  ampls_path  = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Insights/privateLinkScopes/${local._scope_name}"

  body = merge(
    {
      location = var.location
      properties = merge(
        {
          accessModeSettings = merge(
            {
              ingestionAccessMode = var.ingestion_access_mode
              queryAccessMode     = var.query_access_mode
            },
            length(var.access_mode_exclusions) > 0 ? { exclusions = var.access_mode_exclusions } : {},
          )
        },
      )
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Insights"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "monitor_private_link_scope" {
  path            = local.ampls_path
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
    "properties.privateEndpointConnections",
  ])

  # PUT is synchronous — no poll_create needed.
  # DELETE is long-running — polls until 404.
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = ["404"]
      pending = ["202", "200"]
    }
  }
}
