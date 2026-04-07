# Entra ID Group Member Module

Manages a group membership in Entra ID (Azure AD) via the Microsoft Graph v1.0 API.

Adds a directory object (user, group, or service principal) as a member of a group.

## Provider

Requires the `rest` provider configured with `base_url = "https://graph.microsoft.com"` and a token scoped to `https://graph.microsoft.com/.default`.

## API Reference

- [Add member](https://learn.microsoft.com/en-us/graph/api/group-post-members)
- [Remove member](https://learn.microsoft.com/en-us/graph/api/group-delete-members)

## Usage

```hcl
module "group_member" {
  source = "./modules/entraid/group_member"

  providers = {
    rest = rest.graph
  }

  group_id  = module.group.id
  member_id = module.user.id
}
```

## Inputs

| Name | Type | Required | Description |
|------|------|----------|-------------|
| `group_id` | `string` | yes | Object ID of the group |
| `member_id` | `string` | yes | Object ID of the member to add |

## Outputs

| Name | Description |
|------|-------------|
| `group_id` | Object ID of the group (plan-time) |
| `member_id` | Object ID of the member (plan-time) |
