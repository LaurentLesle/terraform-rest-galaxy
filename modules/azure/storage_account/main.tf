# Source: azure-rest-api-specs
#   spec_path : storage/resource-manager/Microsoft.Storage
#   api_version: 2025-08-01
#   operation  : StorageAccounts_Create  (PUT, async — Location header polling)
#   delete     : StorageAccounts_Delete  (DELETE, synchronous)

locals {
  api_version = "2025-08-01"
  sa_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.Storage/storageAccounts/${var.account_name}"

  # identity block — omit entirely when not provided
  identity = var.identity_type != null ? merge(
    { type = var.identity_type },
    var.identity_user_assigned_identity_ids != null ? {
      userAssignedIdentities = { for id in var.identity_user_assigned_identity_ids : id => {} }
    } : {}
  ) : null

  # encryption block — CMK configuration
  encryption = var.encryption_key_source != null ? merge(
    { keySource = var.encryption_key_source },
    var.encryption_key_vault_uri != null ? {
      keyvaultproperties = merge(
        { keyvaulturi = var.encryption_key_vault_uri },
        var.encryption_key_name != null ? { keyname = var.encryption_key_name } : {},
        var.encryption_key_version != null ? { keyversion = var.encryption_key_version } : {},
      )
    } : {},
    var.encryption_identity != null ? {
      identity = { userAssignedIdentity = var.encryption_identity }
    } : {},
    var.encryption_require_infrastructure_encryption != null ? {
      requireInfrastructureEncryption = var.encryption_require_infrastructure_encryption
    } : {},
  ) : null

  # network rule set — translate to ARM field names
  network_acls = var.network_acls != null ? {
    defaultAction = var.network_acls.default_action
    bypass        = var.network_acls.bypass
    ipRules       = [for ip in var.network_acls.ip_rules : { value = ip }]
    virtualNetworkRules = [
      for id in var.network_acls.virtual_network_subnet_ids : { id = id }
    ]
  } : null

  # properties sub-object — only include explicitly set values
  properties = merge(
    { supportsHttpsTrafficOnly = var.https_traffic_only_enabled },
    { minimumTlsVersion = var.minimum_tls_version },
    { allowBlobPublicAccess = var.allow_blob_public_access },
    var.access_tier != null ? { accessTier = var.access_tier } : {},
    var.allow_shared_key_access != null ? { allowSharedKeyAccess = var.allow_shared_key_access } : {},
    var.is_hns_enabled != null ? { isHnsEnabled = var.is_hns_enabled } : {},
    var.public_network_access != null ? { publicNetworkAccess = var.public_network_access } : {},
    var.default_to_oauth_authentication != null ? { defaultToOAuthAuthentication = var.default_to_oauth_authentication } : {},
    var.allow_cross_tenant_replication != null ? { allowCrossTenantReplication = var.allow_cross_tenant_replication } : {},
    local.network_acls != null ? { networkAcls = local.network_acls } : {},
    local.encryption != null ? { encryption = local.encryption } : {},
  )

  body = merge(
    {
      sku        = { name = var.sku_name }
      kind       = var.kind
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
    local.identity != null ? { identity = local.identity } : {},
    var.zones != null ? { zones = var.zones } : {},
  )
}

# ── Resource provider registration check ──────────────────────────────────────
data "rest_resource" "provider_check" {
  id = "/subscriptions/${var.subscription_id}/providers/Microsoft.Storage"

  query = {
    api-version = ["2025-04-01"]
  }

  output_attrs = toset(["registrationState"])
}

# ── Name availability pre-check ──────────────────────────────────────────────
# POST /subscriptions/{id}/providers/Microsoft.Storage/checkNameAvailability
# Runs at apply time (before the PUT). Skipped when importing (check_existance).

resource "rest_operation" "check_name_availability" {
  count  = var.check_existance ? 0 : 1
  path   = "/subscriptions/${var.subscription_id}/providers/Microsoft.Storage/checkNameAvailability"
  method = "POST"

  query = {
    api-version = [local.api_version]
  }

  body = {
    name = var.account_name
    type = "Microsoft.Storage/storageAccounts"
  }

  output_attrs = toset(["nameAvailable", "reason", "message"])
}

resource "rest_resource" "storage_account" {
  path            = local.sa_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.primaryEndpoints.blob",
    "properties.primaryEndpoints.file",
    "properties.primaryEndpoints.queue",
    "properties.primaryEndpoints.table",
    "properties.primaryEndpoints.dfs",
    "type",
  ])

  # Name availability pre-check — fail with a clear message before the PUT.
  # The check_name_availability operation runs first (implicit dependency via
  # the precondition reference), then this precondition evaluates.
  # No try() — if the output is unreadable, we want a loud error, not a silent pass.
  lifecycle {
    precondition {
      condition     = data.rest_resource.provider_check.output.registrationState == "Registered"
      error_message = "Resource provider Microsoft.Storage is not registered on subscription ${var.subscription_id}. Add to your config YAML:\n\n  azure_resource_provider_registrations:\n    storage:\n      resource_provider_namespace: Microsoft.Storage"
    }
    precondition {
      condition     = var.check_existance || rest_operation.check_name_availability[0].output.nameAvailable
      error_message = "Storage account name '${var.account_name}' is not available: ${try(rest_operation.check_name_availability[0].output.message, "unknown reason")}. Choose a different account_name."
    }
  }

  # PUT may complete synchronously (200/201) or asynchronously (202+LRO headers).
  # Polling the resource's own path via provisioningState works for both cases —
  # no url_locator means the provider re-GETs the original resource path.
  # The provider honours the Retry-After response header automatically;
  # default_delay_sec is the fallback when the header is absent.
  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 5
    status = {
      success = "Succeeded"
      pending = ["Creating", "Updating", "Accepted", "Resolving", "ResolvingDns", "Provisioning"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 5
    status = {
      success = "Succeeded"
      pending = ["Updating", "Accepted", "Resolving", "ResolvingDns", "Provisioning"]
    }
  }

  # DELETE is synchronous — no poll_delete needed.
}
