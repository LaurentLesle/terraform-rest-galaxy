# Entra ID User Module

Manages an Entra ID (Azure AD) user via the Microsoft Graph v1.0 API.

## Provider

Requires the `rest` provider configured with `base_url = "https://graph.microsoft.com"` and a token scoped to `https://graph.microsoft.com/.default`.

## API Reference

- [Create user](https://learn.microsoft.com/en-us/graph/api/user-post-users)
- [Update user](https://learn.microsoft.com/en-us/graph/api/user-update)
- [Delete user](https://learn.microsoft.com/en-us/graph/api/user-delete)

## Usage

```hcl
module "user" {
  source = "./modules/entraid/user"

  providers = {
    rest = rest.graph
  }

  display_name        = "Jane Doe"
  mail_nickname       = "janedoe"
  user_principal_name = "janedoe@contoso.onmicrosoft.com"
  account_enabled     = true
  password_profile = {
    password                           = "SecureP@ss123!"
    force_change_password_next_sign_in = true
  }
}
```

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `display_name` | `string` | yes | – | Display name |
| `mail_nickname` | `string` | yes | – | Mail alias |
| `user_principal_name` | `string` | yes | – | UPN (alias@domain) |
| `account_enabled` | `bool` | yes | – | Account enabled flag |
| `password_profile` | `object` | yes | – | Password profile (sensitive) |
| `given_name` | `string` | no | `null` | First name |
| `surname` | `string` | no | `null` | Last name |
| `job_title` | `string` | no | `null` | Job title |
| `department` | `string` | no | `null` | Department |
| `office_location` | `string` | no | `null` | Office location |
| `city` | `string` | no | `null` | City |
| `country` | `string` | no | `null` | Country |
| `state` | `string` | no | `null` | State/province |
| `postal_code` | `string` | no | `null` | Postal code |
| `street_address` | `string` | no | `null` | Street address |
| `company_name` | `string` | no | `null` | Company name |
| `mobile_phone` | `string` | no | `null` | Mobile phone |
| `preferred_language` | `string` | no | `null` | Preferred language (ISO 639-1) |
| `usage_location` | `string` | no | `null` | Country code (ISO 3166) |
| `user_type` | `string` | no | `null` | Member or Guest |
| `employee_id` | `string` | no | `null` | Employee ID |
| `employee_type` | `string` | no | `null` | Employee type |
| `other_mails` | `list(string)` | no | `null` | Additional email addresses |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Object ID (known after apply) |
| `display_name` | Display name (plan-time) |
| `user_principal_name` | UPN (plan-time) |
| `mail_nickname` | Mail alias (plan-time) |
| `account_enabled` | Account enabled flag (plan-time) |
| `created_date_time` | Creation timestamp (known after apply) |
