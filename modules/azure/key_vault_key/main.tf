# Source: azure-rest-api-specs
#   spec_path : keyvault/resource-manager/Microsoft.KeyVault/KeyVault
#   api_version: 2026-02-01
#   operation  : Keys_CreateIfNotExist  (PUT, synchronous)
#   note       : No DELETE operation on management-plane keys; lifecycle tied to vault.

locals {
  api_version = "2026-02-01"
  key_path    = "/subscriptions/${var.subscription_id}/resourceGroups/${var.resource_group_name}/providers/Microsoft.KeyVault/vaults/${var.vault_name}/keys/${var.key_name}"

  properties = merge(
    { kty = var.key_type },
    var.key_size != null ? { keySize = var.key_size } : {},
    var.curve_name != null ? { curveName = var.curve_name } : {},
    var.key_ops != null ? { keyOps = var.key_ops } : {},
  )

  body = merge(
    { properties = local.properties },
    var.tags != null ? { tags = var.tags } : {},
  )
}

resource "rest_operation" "key_vault_key" {
  path   = local.key_path
  method = "PUT"

  query = {
    api-version = [local.api_version]
  }

  body = local.body

  # PUT is synchronous — no polling needed.
  # No delete_method: management-plane keys don't support DELETE (lifecycle tied to vault).
}
