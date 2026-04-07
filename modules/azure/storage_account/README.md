# Azure Storage Account Module

Manages an Azure Storage Account using the `laurentlesle/rest` Terraform provider and the official Azure REST API spec. No `azurerm` dependency.

## API Version

`2025-08-01` — latest stable as of module generation (26 March 2026).
Spec: `storage/resource-manager/Microsoft.Storage`.

## Usage

```hcl
module "storage_account" {
  source = "./modules/storage_account"

  subscription_id     = "00000000-0000-0000-0000-000000000000"
  resource_group_name = "rg-myapp-prod"
  account_name        = "mystorageaccount"
  sku_name            = "Standard_LRS"
  kind                = "StorageV2"
  location            = "westeurope"

  https_traffic_only_enabled = true
  minimum_tls_version        = "TLS1_2"
  allow_blob_public_access   = false

  tags = {
    environment = "production"
    team        = "platform"
  }
}
```

## Inputs

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `subscription_id` | `string` | yes | Azure subscription ID |
| `resource_group_name` | `string` | yes | Parent resource group name |
| `account_name` | `string` | yes | Globally unique storage account name (3–24 alphanumeric) |
| `sku_name` | `string` | yes | SKU name (Standard_LRS, Standard_GRS, Premium_LRS, etc.) |
| `kind` | `string` | yes | Account kind (StorageV2, BlobStorage, FileStorage, BlockBlobStorage) |
| `location` | `string` | yes | Azure region (immutable after creation) |
| `tags` | `map(string)` | no | Resource tags (max 15) |
| `zones` | `list(string)` | no | Pinned availability zones |
| `identity_type` | `string` | no | Managed identity type (SystemAssigned, UserAssigned, etc.) |
| `identity_user_assigned_identity_ids` | `list(string)` | no | User-assigned identity ARM IDs |
| `access_tier` | `string` | no | Billing access tier — required for BlobStorage kind |
| `https_traffic_only_enabled` | `bool` | no | Enforce HTTPS only (default: `true`) |
| `minimum_tls_version` | `string` | no | Minimum TLS version (default: `TLS1_2`) |
| `allow_blob_public_access` | `bool` | no | Allow public blob access (default: `false`) |
| `allow_shared_key_access` | `bool` | no | Permit Shared Key authorization |
| `is_hns_enabled` | `bool` | no | Enable ADLS Gen2 hierarchical namespace (immutable) |
| `public_network_access` | `string` | no | Public network access (Enabled, Disabled, SecuredByPerimeter) |
| `default_to_oauth_authentication` | `bool` | no | Default auth to Entra ID/OAuth |
| `allow_cross_tenant_replication` | `bool` | no | Allow cross-AAD-tenant replication |
| `network_acls` | `object` | no | Network ACL rules (default_action, bypass, ip_rules, subnet IDs) |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Full ARM resource ID |
| `api_version` | ARM API version used |
| `name` | Storage account name (from ARM) |
| `type` | ARM resource type string |
| `location` | Deployed Azure region |
| `kind` | Account kind (from ARM) |
| `sku_name` | SKU name (from ARM) |
| `provisioning_state` | Provisioning state (e.g. Succeeded) |
| `primary_blob_endpoint` | Primary Blob service URL |
| `primary_file_endpoint` | Primary File service URL |
| `primary_queue_endpoint` | Primary Queue service URL |
| `primary_table_endpoint` | Primary Table service URL |
| `primary_dfs_endpoint` | Primary ADLS Gen2 / DFS endpoint URL |

## Long-running Operations

| Operation | LRO | Polling |
|-----------|-----|---------|
| Create (PUT) | Yes | `header.Location`, Retry-After honoured |
| Update (PUT) | Yes | `header.Location`, Retry-After honoured |
| Delete (DELETE) | No | Synchronous |
