# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Monitor/preview/2023-10-01-preview/azuremonitor.json
#   api_version: 2023-10-01-preview
#   stability  : preview (no stable version available as of generation)
#   operation  : AzureMonitorWorkspaces_CreateOrUpdate (PUT, long-running)
#   delete     : AzureMonitorWorkspaces_Delete (DELETE, long-running — Location header)

locals {
  api_version = "2023-10-01-preview"
  amw_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Monitor/accounts/${var.monitor_workspace_name}"

  body = merge(
    { location = var.location },
    var.tags != null ? { tags = var.tags } : {},
  )
}

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Monitor"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "monitor_workspace" {
  path            = local.amw_path
  create_method   = "PUT"
  check_existance = var.check_existance

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Monitor is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    monitor:\n      resource_provider_namespace: Microsoft.Monitor"
    }
  }

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.metrics.prometheusQueryEndpoint",
    "properties.defaultIngestionSettings.dataCollectionRuleResourceId",
    "properties.defaultIngestionSettings.dataCollectionEndpointResourceId",
  ])

  # PUT is long-running with azure-async-operation header.
  poll_create = {
    status_locator    = "body.status"
    url_locator       = "header.Azure-AsyncOperation"
    default_delay_sec = 15
    status = {
      success = ["Succeeded"]
      pending = ["Creating", "Updating", "Accepted", "Running", "InProgress"]
    }
  }

  poll_update = {
    status_locator    = "body.status"
    url_locator       = "header.Azure-AsyncOperation"
    default_delay_sec = 15
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Accepted", "Running", "InProgress"]
    }
  }

  # DELETE is async — polls until resource returns 404.
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 15
    status = {
      success = ["404"]
      pending = ["202", "200"]
    }
  }
}
