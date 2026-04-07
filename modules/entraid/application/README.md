# Entra ID Application Module

Manages an Entra ID (Azure AD) application registration via **Microsoft Graph API v1.0**.

> **Provider**: This module uses `laurentlesle/rest ~> 1.0` configured with
> `base_url = "https://graph.microsoft.com"`. The caller must pass a provider
> alias with a token scoped to `https://graph.microsoft.com/.default`.

## API Reference

- **Create**: `POST /v1.0/applications`
- **Read**: `GET /v1.0/applications/{id}`
- **Update**: `PATCH /v1.0/applications/{id}`
- **Delete**: `DELETE /v1.0/applications/{id}`

## Usage

```hcl
provider "rest" {
  alias    = "graph"
  base_url = "https://graph.microsoft.com"
  security = {
    http = {
      token = {
        token = var.graph_access_token
      }
    }
  }
}

module "my_app" {
  source = "./modules/azure/application"
  providers = {
    rest = rest.graph
  }

  display_name     = "my-application"
  sign_in_audience = "AzureADMyOrg"
}
```

## Inputs

| Name | Type | Required | Default | Description |
|------|------|----------|---------|-------------|
| `display_name` | `string` | yes | — | The display name for the application |
| `sign_in_audience` | `string` | no | `"AzureADMyOrg"` | Supported Microsoft accounts |
| `description` | `string` | no | `null` | Free text description (max 1024 chars) |
| `notes` | `string` | no | `null` | Management notes |
| `identifier_uris` | `list(string)` | no | `null` | App ID URIs |
| `tags` | `list(string)` | no | `null` | Custom categorization strings |
| `group_membership_claims` | `string` | no | `null` | Groups claim config |
| `is_fallback_public_client` | `bool` | no | `false` | Fallback to public client |
| `is_device_only_auth_supported` | `bool` | no | `null` | Device auth without user |
| `web` | `object` | no | `null` | Web application settings |
| `spa` | `object` | no | `null` | Single-page application settings |
| `public_client` | `object` | no | `null` | Installed client settings |
| `api` | `object` | no | `null` | Web API settings |
| `required_resource_access` | `list(object)` | no | `null` | API permissions |
| `app_roles` | `list(object)` | no | `null` | App role definitions |
| `optional_claims` | `object` | no | `null` | Optional claims config |

## Outputs

| Name | Description |
|------|-------------|
| `id` | Object ID (known after apply) |
| `app_id` | Application (client) ID (known after apply) |
| `display_name` | Display name (plan-time) |
| `sign_in_audience` | Sign-in audience (plan-time) |
| `publisher_domain` | Verified publisher domain (known after apply) |
| `created_date_time` | Registration timestamp (known after apply) |
| `identifier_uris` | Identifier URIs (known after apply) |
