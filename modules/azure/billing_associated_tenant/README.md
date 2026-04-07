# billing\_associated\_tenant

Manages an [associated billing tenant](https://learn.microsoft.com/en-us/azure/cost-management-billing/manage/manage-billing-across-tenants) for a Microsoft Customer Agreement (Enterprise) billing account.

Associated billing tenants let you create multitenant billing relationships — securely sharing a billing account across tenants for billing management and/or subscription provisioning.

## API Reference

- **Provider**: `Microsoft.Billing`
- **Resource type**: `billingAccounts/associatedTenants`
- **API version**: `2024-04-01`
- **PUT**: `AssociatedTenants_CreateOrUpdate` (long-running, Location header)
- **DELETE**: `AssociatedTenants_Delete` (long-running, Location header)

## Prerequisites

- A **Microsoft Customer Agreement – Enterprise** billing account (created via a Microsoft sales representative)
- The caller must have billing account owner role on the billing account

## Usage

```hcl
module "billing_associated_tenant" {
  source = "./modules/azure/billing_associated_tenant"

  billing_account_name          = "12345678:12345678-1234-1234-1234-123456789012_2024-01-01"
  tenant_id                     = "aaaabbbb-cccc-dddd-eeee-ffffgggggggg"
  display_name                  = "Partner Tenant"
  billing_management_state      = "Active"
  provisioning_management_state = "Pending"
}
```
