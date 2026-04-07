# Billing Role Assignment

Manages a billing role assignment on an Azure billing account using the `Microsoft.Billing` REST API.

## API Reference

- **PUT** `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleAssignments/{billingRoleAssignmentName}`
- **DELETE** `/providers/Microsoft.Billing/billingAccounts/{billingAccountName}/billingRoleAssignments/{billingRoleAssignmentName}`
- API version: `2024-04-01`

## Well-known Billing Role Definitions

These are per-billing-account. Use the billing role definitions API to list them:

```
GET /providers/Microsoft.Billing/billingAccounts/{name}/billingRoleDefinitions?api-version=2024-04-01
```

Common roles:
| Role | Description |
|------|-------------|
| Billing account owner | Full access including role management |
| Billing account contributor | All permissions except role management |
| Billing account reader | Read-only access |
| Signatory | Can sign agreements |

## Usage

```hcl
module "billing_role_assignment" {
  source = "./modules/azure/billing_role_assignment"

  billing_account_name = "12345678-...:12345678-..._2019-05-31"
  principal_id         = "00000000-0000-0000-0000-000000000000"
  principal_tenant_id  = "00000000-0000-0000-0000-000000000000"
  role_definition_id   = "/providers/Microsoft.Billing/billingAccounts/.../billingRoleDefinitions/..."
  principal_type       = "User"
}
```
