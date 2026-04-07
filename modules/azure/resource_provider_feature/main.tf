# Source: azure-rest-api-specs
#   spec_path : resources/resource-manager/Microsoft.Features/features
#   api_version: 2021-07-01
#   operation  : SubscriptionFeatureRegistrations_CreateOrUpdate  (PUT, synchronous)
#   delete     : SubscriptionFeatureRegistrations_Delete          (DELETE, synchronous)

locals {
  api_version  = "2021-07-01"
  feature_path = "/subscriptions/${var.subscription_id}/providers/Microsoft.Features/featureProviders/${var.provider_namespace}/subscriptionFeatureRegistrations/${var.feature_name}"

  properties = merge(
    { state = var.state },
    var.metadata != null ? { metadata = var.metadata } : {},
    var.description != null ? { description = var.description } : {},
    var.should_feature_display_in_portal != null ? { shouldFeatureDisplayInPortal = var.should_feature_display_in_portal } : {},
  )

  body = {
    properties = local.properties
  }
}

resource "rest_resource" "feature_registration" {
  path            = local.feature_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.state",
  ])
}
