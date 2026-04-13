# Source: azure-rest-api-specs
#   spec_path : subscription/resource-manager/Microsoft.Subscription/Subscription
#   api_version: 2021-10-01
#   operation  : Alias_Create  (PUT, long-running — Retry-After header)
#   delete     : Alias_Delete  (DELETE, synchronous — deletes the alias, not the subscription)

locals {
  api_version = "2021-10-01"
  alias_path  = "/providers/Microsoft.Subscription/aliases/${var.alias_name}"

  additional_properties = merge(
    var.management_group_id != null ? { managementGroupId = var.management_group_id } : {},
    var.subscription_tenant_id != null ? { subscriptionTenantId = var.subscription_tenant_id } : {},
    var.subscription_owner_id != null ? { subscriptionOwnerId = var.subscription_owner_id } : {},
    var.tags != null ? { tags = var.tags } : {},
  )

  properties = merge(
    {
      displayName  = var.display_name
      billingScope = var.billing_scope
      workload     = var.workload
    },
    var.subscription_id != null ? { subscriptionId = var.subscription_id } : {},
    var.reseller_id != null ? { resellerId = var.reseller_id } : {},
    length(local.additional_properties) > 0 ? { additionalProperties = local.additional_properties } : {},
  )

  body = {
    properties = local.properties
  }
}

resource "rest_resource" "subscription" {
  path            = local.alias_path
  create_method   = "PUT"
  check_existance = var.check_existance
  auth_ref        = var.auth_ref

  # Azure throttles Alias_Create tenant-wide (~5/min). Two-part mitigation:
  #
  # 1) Serialize PUTs across all instances of this module with a mutex. Without
  #    this, `for_each` fires N parallel PUTs; after the first 429 they all
  #    retry in lockstep, hammer the same throttle bucket, and Azure ratchets
  #    the cooldown from ~76s up to 13+ minutes. Holding a shared mutex limits
  #    in-flight PUTs to one at a time so the throttle is never saturated.
  #
  # 2) Retry on 429 response body. Azure's 429 does NOT carry an HTTP
  #    `Retry-After` header — the wait is only in the JSON body ("Retry in
  #    00:01:16.") — so the provider-level retry is blind to it. The
  #    resource-level body-regex retry waits 90s (over Azure's ~76s hint) and
  #    tries up to 15 times. Scoped to this resource only.
  precheck_create = [{ mutex = "azure-subscription-alias-create" }]

  retry = {
    error_message_regex = ["TooManyRequests"]
    interval_seconds    = 90
    max_attempts        = 15
  }

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  # The Alias GET response only returns subscriptionId and provisioningState.
  # All other properties (displayName, billingScope, workload, etc.) are
  # create-only — sent in the PUT but absent from the GET response body.
  # Without write_only_attrs the provider sees null for every planned value
  # and fails with "Provider produced inconsistent result after apply".
  write_only_attrs = toset(concat(
    [
      "properties.displayName",
      "properties.billingScope",
      "properties.workload",
    ],
    length(local.additional_properties) > 0 ? ["properties.additionalProperties"] : [],
    var.subscription_id != null ? ["properties.subscriptionId"] : [],
    var.reseller_id != null ? ["properties.resellerId"] : [],
  ))

  output_attrs = toset([
    "properties.subscriptionId",
    "properties.provisioningState",
  ])

  # PUT is long-running; ARM returns 200/201 with provisioningState.
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 10
    status = {
      success = "Succeeded"
      pending = ["Accepted"]
    }
  }

  # DELETE is synchronous — deletes the alias only, not the subscription.

  lifecycle {
    # Subscription alias properties (billingScope, displayName, workload) are
    # create-only — the GET response returns a different subset than what was
    # PUT. Ignoring body changes prevents false drift from triggering updates
    # that would make subscription_id unknown and cascade forced replacements.
    ignore_changes = [body]
  }
}
