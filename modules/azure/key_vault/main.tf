# Source: azure-rest-api-specs
#   spec_path : keyvault/resource-manager/Microsoft.KeyVault/KeyVault
#   api_version: 2026-02-01
#   operation  : Vaults_CreateOrUpdate  (PUT, async — Location header polling)
#   delete     : Vaults_Delete          (DELETE, synchronous)

locals {
  api_version = "2026-02-01"
  kv_path     = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.vault_name}"

  network_acls = var.network_acls != null ? {
    defaultAction       = var.network_acls.default_action
    bypass              = var.network_acls.bypass
    ipRules             = [for ip in var.network_acls.ip_rules : { value = ip }]
    virtualNetworkRules = var.network_acls.virtual_network_rules
  } : null

  properties = merge(
    {
      tenantId                  = var.tenant_id
      sku                       = { family = "A", name = var.sku_name }
      enableRbacAuthorization   = var.enable_rbac_authorization
      enableSoftDelete          = var.enable_soft_delete
      softDeleteRetentionInDays = var.soft_delete_retention_in_days
    },
    var.create_mode != null ? { createMode = var.create_mode } : {},
    var.enable_purge_protection != null ? { enablePurgeProtection = var.enable_purge_protection } : {},
    var.enabled_for_deployment != null ? { enabledForDeployment = var.enabled_for_deployment } : {},
    var.enabled_for_disk_encryption != null ? { enabledForDiskEncryption = var.enabled_for_disk_encryption } : {},
    var.enabled_for_template_deployment != null ? { enabledForTemplateDeployment = var.enabled_for_template_deployment } : {},
    var.public_network_access != null ? { publicNetworkAccess = var.public_network_access } : {},
    local.network_acls != null ? { networkAcls = local.network_acls } : {},
  )

  body = merge(
    {
      location   = var.location
      properties = local.properties
    },
    var.tags != null ? { tags = var.tags } : {},
  )
}

# ── Name availability pre-check ──────────────────────────────────────────────
# POST /subscriptions/{id}/providers/Microsoft.KeyVault/checkNameAvailability
# Runs at apply time (before the PUT). Skipped when importing (check_existance).

resource "rest_operation" "check_name_availability" {
  count  = var.check_existance ? 0 : 1
  path   = "/subscriptions/${var.subscription_id}/providers/Microsoft.KeyVault/checkNameAvailability"
  method = "POST"

  query = {
    api-version = [local.api_version]
  }

  body = {
    name = var.vault_name
    type = "Microsoft.KeyVault/vaults"
  }

  output_attrs = toset(["nameAvailable", "reason", "message"])
}

resource "rest_resource" "key_vault" {
  path            = local.kv_path
  create_method   = "PUT"
  check_existance = var.check_existance

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  output_attrs = toset([
    "properties.provisioningState",
    "properties.tenantId",
    "type",
  ])

  lifecycle {
    precondition {
      condition     = var.check_existance || rest_operation.check_name_availability[0].output.nameAvailable
      error_message = "Key vault name '${var.vault_name}' is not available: ${try(rest_operation.check_name_availability[0].output.message, "unknown reason")}. Choose a different vault_name."
    }
  }

  poll_create = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 5
    status = {
      success = ["Succeeded"]
      pending = ["Provisioning", "Accepted", "RegisteringDns"]
    }
  }

  poll_update = {
    status_locator    = "body.properties.provisioningState"
    default_delay_sec = 5
    status = {
      success = ["Succeeded"]
      pending = ["Provisioning", "Accepted", "RegisteringDns"]
    }
  }

  # DELETE is synchronous — no poll_delete needed.
}
