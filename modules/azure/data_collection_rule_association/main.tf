# Source: azure-rest-api-specs
#   spec_path  : monitor/resource-manager/Microsoft.Insights/Insights/stable/2024-03-11/dataCollectionRuleAssociations_API.json
#   api_version: 2024-03-11
#   stability  : stable
#   operation  : DataCollectionRuleAssociations_Create (PUT, synchronous — 200/201)
#   delete     : DataCollectionRuleAssociations_Delete (DELETE, synchronous — 200/204)
#   Note: Uses scope-based ARM path — /{resourceUri}/providers/Microsoft.Insights/dataCollectionRuleAssociations/{name}

locals {
  api_version = "2024-03-11"
  dcra_path   = "${var.resource_id}/providers/Microsoft.Insights/dataCollectionRuleAssociations/${var.association_name}"

  properties = merge(
    var.description != null ? { description = var.description } : {},
    var.data_collection_rule_id != null ? { dataCollectionRuleId = var.data_collection_rule_id } : {},
    var.data_collection_endpoint_id != null ? { dataCollectionEndpointId = var.data_collection_endpoint_id } : {},
  )

  body = {
    properties = local.properties
  }
}

data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Insights"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

resource "rest_resource" "data_collection_rule_association" {
  path            = local.dcra_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
  ])

  # PUT is synchronous (200/201) — no polling needed.

  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Insights is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    insights:\n      resource_provider_namespace: Microsoft.Insights"
    }

    precondition {
      condition     = !(var.data_collection_rule_id != null && var.data_collection_endpoint_id != null)
      error_message = "data_collection_rule_id and data_collection_endpoint_id are mutually exclusive. Specify only one."
    }

    precondition {
      condition     = var.data_collection_rule_id != null || var.data_collection_endpoint_id != null
      error_message = "At least one of data_collection_rule_id or data_collection_endpoint_id must be specified."
    }
  }
}
