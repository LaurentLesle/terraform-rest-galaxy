# Entra ID Group Module

Manages an Entra ID (Azure AD) security or Microsoft 365 group via the Microsoft Graph v1.0 API.

## Provider

Requires the `rest` provider configured with `base_url = "https://graph.microsoft.com"` and a token scoped to `https://graph.microsoft.com/.default`.

## API Reference

- [Create group](https://learn.microsoft.com/en-us/graph/api/group-post-groups)
- [Update group](https://learn.microsoft.com/en-us/graph/api/group-update)
- [Delete group](https://learn.microsoft.com/en-us/graph/api/group-delete)

## Usage

```hcl
module "group" {
  source = "./modules/entraid/group"

  providers = {
    rest = rest.graph
  }

  display_name     = "my-security-group"
  mail_enabled     = false
  mail_nickname    = "my-security-group"
  security_enabled = true
}
```

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `display_name` | `string` | yes | – | Display name for the group |
| `mail_enabled` | `bool` | yes | – | Whether the group is mail-enabled |
| `mail_nickname` | `string` | yes | – | Mail alias for the group |
| `security_enabled` | `bool` | yes | – | Whether the group is a security group |
| `description` | `string` | no | `null` | Optional description |
| `group_types` | `list(string)` | no | `null` | Group type (e.g. `["Unified"]` for M365) |
| `visibility` | `string` | no | `null` | Join policy: Private, Public, HiddenMembership |
| `is_assignable_to_role` | `bool` | no | `null` | Whether assignable to Azure AD role |
| `membership_rule` | `string` | no | `null` | Dynamic membership rule |
| `membership_rule_processing_state` | `string` | no | `null` | On or Paused |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Object ID (known after apply) |
| `display_name` | Display name (plan-time) |
| `mail_nickname` | Mail alias (plan-time) |
| `security_enabled` | Security group flag (plan-time) |
| `mail_enabled` | Mail-enabled flag (plan-time) |
| `created_date_time` | Creation timestamp (known after apply) |
