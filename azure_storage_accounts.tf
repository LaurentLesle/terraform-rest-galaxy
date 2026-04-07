# ── Storage Accounts ──────────────────────────────────────────────────────────

variable "azure_storage_accounts" {
  type = map(object({
    subscription_id                     = string
    resource_group_name                 = string
    account_name                        = string
    sku_name                            = string
    kind                                = string
    location                            = optional(string, null) # null → resolved from var.default_location
    tags                                = optional(map(string), null)
    zones                               = optional(list(string), null)
    identity_type                       = optional(string, null)
    identity_user_assigned_identity_ids = optional(list(string), null)
    access_tier                         = optional(string, null)
    https_traffic_only_enabled          = optional(bool, true)
    minimum_tls_version                 = optional(string, "TLS1_2")
    allow_blob_public_access            = optional(bool, false)
    allow_shared_key_access             = optional(bool, null)
    is_hns_enabled                      = optional(bool, null)
    public_network_access               = optional(string, null)
    default_to_oauth_authentication     = optional(bool, null)
    allow_cross_tenant_replication      = optional(bool, null)
    network_acls = optional(object({
      default_action             = string
      bypass                     = optional(list(string), ["AzureServices"])
      ip_rules                   = optional(list(string), [])
      virtual_network_subnet_ids = optional(list(string), [])
    }), null)
    encryption_key_source                        = optional(string, null)
    encryption_key_vault_uri                     = optional(string, null)
    encryption_key_name                          = optional(string, null)
    encryption_key_version                       = optional(string, null)
    encryption_identity                          = optional(string, null)
    encryption_require_infrastructure_encryption = optional(bool, null)
  }))
  description = <<-EOT
    Map of storage accounts to create or manage. Each map key acts as the for_each
    identifier and must be unique within this configuration.

    Example:
      azure_storage_accounts = {
        app_data = {
          subscription_id     = "00000000-0000-0000-0000-000000000000"
          resource_group_name = "rg-myapp-prod"
          account_name        = "myappdata"  # globally unique, 3-24 lowercase alphanumeric
          sku_name            = "Standard_LRS"
          kind                = "StorageV2"
          # location omitted → resolved from var.default_location
          tags = {
            environment = "production"
            team        = "platform"
          }
        }
        datalake = {
          subscription_id     = "00000000-0000-0000-0000-000000000000"
          resource_group_name = "rg-data-prod"
          account_name        = "mydatalakeprod"  # explicit override
          sku_name            = "Standard_ZRS"
          kind                = "StorageV2"
          location            = "northeurope"
          is_hns_enabled      = true
        }
      }
  EOT
  default     = {}
}

locals {
  azure_storage_accounts = provider::rest::resolve_map(
    local._ctx_l2,
    merge(try(local._yaml_raw.azure_storage_accounts, {}), var.azure_storage_accounts)
  )
  _sa_ctx = provider::rest::merge_with_outputs(local.azure_storage_accounts, module.azure_storage_accounts)
}

module "azure_storage_accounts" {
  source   = "./modules/azure/storage_account"
  for_each = local.azure_storage_accounts

  depends_on = [module.azure_key_vault_keys, module.azure_role_assignments]

  subscription_id                              = try(each.value.subscription_id, var.subscription_id)
  resource_group_name                          = each.value.resource_group_name
  account_name                                 = each.value.account_name
  sku_name                                     = each.value.sku_name
  kind                                         = each.value.kind
  location                                     = try(each.value.location != null ? each.value.location : local.default_location, local.default_location)
  tags                                         = try(each.value.tags, null)
  zones                                        = try(each.value.zones, null)
  identity_type                                = try(each.value.identity_type, null)
  identity_user_assigned_identity_ids          = try(each.value.identity_user_assigned_identity_ids, null)
  access_tier                                  = try(each.value.access_tier, null)
  https_traffic_only_enabled                   = try(each.value.https_traffic_only_enabled, true)
  minimum_tls_version                          = try(each.value.minimum_tls_version, "TLS1_2")
  allow_blob_public_access                     = try(each.value.allow_blob_public_access, false)
  allow_shared_key_access                      = try(each.value.allow_shared_key_access, null)
  is_hns_enabled                               = try(each.value.is_hns_enabled, null)
  public_network_access                        = try(each.value.public_network_access, null)
  default_to_oauth_authentication              = try(each.value.default_to_oauth_authentication, null)
  allow_cross_tenant_replication               = try(each.value.allow_cross_tenant_replication, null)
  network_acls                                 = try(each.value.network_acls, null)
  encryption_key_source                        = try(each.value.encryption_key_source, null)
  encryption_key_vault_uri                     = try(each.value.encryption_key_vault_uri, null)
  encryption_key_name                          = try(each.value.encryption_key_name, null)
  encryption_key_version                       = try(each.value.encryption_key_version, null)
  encryption_identity                          = try(each.value.encryption_identity, null)
  encryption_require_infrastructure_encryption = try(each.value.encryption_require_infrastructure_encryption, null)
  check_existance                              = var.check_existance
}
