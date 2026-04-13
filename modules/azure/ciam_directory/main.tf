# Source: azure-rest-api-specs
#   spec_path : cpim/resource-manager/Microsoft.AzureActiveDirectory/ExternalIdentities
#   api_version: 2023-05-17-preview
#   operation  : CIAMTenants_Create  (PUT, async — azure-async-operation polling)
#   delete     : CIAMTenants_Delete  (DELETE, async — Location header polling)

locals {
  api_version = "2023-05-17-preview"
  ciam_path   = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.AzureActiveDirectory/ciamDirectories/${var.resource_name}"

  body = merge(
    {
      location = var.location
      sku = {
        name = var.sku_name
        tier = "A0"
      }
      properties = {
        createTenantProperties = {
          displayName = var.display_name
          countryCode = var.country_code
        }
      }
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Name availability pre-check ──────────────────────────────────────────────
# POST /subscriptions/{id}/providers/Microsoft.AzureActiveDirectory/checkNameAvailability
# Runs at apply time (before the PUT). Skipped when importing (check_existance).

resource "rest_operation" "check_name_availability" {
  count  = var.check_existance ? 0 : 1
  path   = "/subscriptions/${var.subscription_id}/providers/Microsoft.AzureActiveDirectory/checkNameAvailability"
  method = "POST"

  query = {
    api-version = [local.api_version]
  }

  body = {
    name        = var.resource_name
    countryCode = var.country_code
  }

  output_attrs = toset(["nameAvailable", "reason", "message"])
}

resource "rest_resource" "ciam_directory" {
  path            = local.ciam_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  # PATCH only supports sku + tags; createTenantProperties and location are create-only.
  update_method = "PATCH"

  # Exclude create-only properties from the update body so PATCH only sends sku + tags.
  write_only_attrs = toset([
    "location",
    "properties",
  ])

  output_attrs = toset([
    "properties.provisioningState",
    "properties.tenantId",
    "properties.domainName",
    "properties.billingConfig",
    "type",
  ])

  lifecycle {
    precondition {
      condition     = var.check_existance || rest_operation.check_name_availability[0].output.nameAvailable
      error_message = "CIAM directory name '${var.resource_name}' is not available: ${try(rest_operation.check_name_availability[0].output.message, "unknown reason")}. Choose a different resource_name."
    }
  }

  # PUT is async via azure-async-operation header.
  # Poll the resource itself for provisioningState.
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 30
    status = {
      success = ["Succeeded"]
      pending = ["Creating", "Pending", "Accepted", "Provisioning", "Updating"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 15
    status = {
      success = ["Succeeded"]
      pending = ["Updating", "Accepted", "Provisioning"]
    }
  }

  # DELETE is async with Location header.
  # Poll until the resource returns 404.
  poll_delete = {
    status_locator    = "code"
    default_delay_sec = 30
    status = {
      success = ["404"]
      pending = ["202", "200"]
    }
  }
}
