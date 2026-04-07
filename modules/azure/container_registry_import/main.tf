# Source: azure-rest-api-specs
#   spec_path  : containerregistry/resource-manager/Microsoft.ContainerRegistry/Registry
#   api_version: 2025-11-01
#   operation  : Registries_ImportImage (POST, async — location polling)

locals {
  api_version = "2025-11-01"
}

resource "rest_operation" "import_image" {
  path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.ContainerRegistry/registries/${var.registry_name}/importImage"
  method = "POST"

  query = {
    api-version = [local.api_version]
  }

  body = merge(
    {
      source = {
        registryUri = var.source_registry_uri
        sourceImage = var.source_image
      }
      mode       = var.mode
      targetTags = var.target_tags != null ? var.target_tags : [var.source_image]
    },
  )

  poll = {
    url_locator       = "header.Location"
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = "200"
      pending = ["202"]
    }
  }
}
