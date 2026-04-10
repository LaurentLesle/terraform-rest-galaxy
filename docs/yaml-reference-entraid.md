# YAML Reference — Entra ID

← [Back to index](yaml-reference.md)

### `entraid_app_role_assignments`

**API version:** `Microsoft Graph v1.0`

Map of app role assignments to create via Microsoft Graph API.
Assigns a user, group, or service principal to an Enterprise Application
(service principal).

Requires var.graph_access_token to be set with a token scoped to
https://graph.microsoft.com/.default.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `resource_app_id` | `string` | yes | — |  |
| `principal_id` | `string` | yes | — |  |
| `app_role_id` | `string` | no | `"00000000-0000-0000-0000-000000000000"` |  |

#### YAML Example

```yaml
entraid_app_role_assignments:
  vpn_users_to_vpn_app:
    resource_app_id: "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"  # Azure VPN Enterprise App
    principal_id: "ref:entraid_groups.vpn_users.id"
```

---

### `entraid_applications`

**API version:** `Microsoft Graph v1.0`

Map of Entra ID application registrations to create via Microsoft Graph API.
Each map key acts as the for_each identifier.

Requires var.graph_access_token to be set with a token scoped to
https://graph.microsoft.com/.default.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `display_name` | `string` | yes | — |  |
| `sign_in_audience` | `string` | no | `"AzureADMyOrg"` |  |
| `description` | `string` | no | `null` |  |
| `notes` | `string` | no | `null` |  |
| `identifier_uris` | `list(string)` | no | `null` |  |
| `tags` | `list(string)` | no | `null` |  |
| `group_membership_claims` | `string` | no | `null` |  |
| `is_fallback_public_client` | `bool` | no | `false` |  |
| `is_device_only_auth_supported` | `bool` | no | `null` |  |
| `web` | `object` | no | `null` |  |
| `spa` | `object` | no | `null` |  |
| `public_client` | `object` | no | `null` |  |
| `api` | `object` | no | `null` |  |
| `required_resource_access` | `list(object)` | no | `null` |  |
| `app_roles` | `list(object)` | no | `null` |  |
| `optional_claims` | `object` | no | `null` |  |

#### YAML Example

```yaml
entraid_applications:
  my_app:
    display_name: "my-application"
    sign_in_audience: "AzureADMyOrg"
    web:
      redirect_uris: ["https://myapp.example.com/auth/callback"]
```

---

### `entraid_group_members`

**API version:** `Microsoft Graph v1.0`

Map of Entra ID group membership links to create via Microsoft Graph API.
Each map key acts as the for_each identifier.

Requires var.graph_access_token to be set with a token scoped to
https://graph.microsoft.com/.default.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `group_id` | `string` | yes | — |  |
| `member_id` | `string` | yes | — |  |

#### YAML Example

```yaml
entraid_group_members:
  jane_in_admins:
    group_id: "ref:entraid_groups.admins.id"
    member_id: "ref:entraid_users.jane.id"
```

---

### `entraid_groups`

**API version:** `Microsoft Graph v1.0`

Map of Entra ID groups to create via Microsoft Graph API.
Each map key acts as the for_each identifier.

Requires var.graph_access_token to be set with a token scoped to
https://graph.microsoft.com/.default.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `display_name` | `string` | yes | — |  |
| `mail_enabled` | `bool` | yes | — |  |
| `mail_nickname` | `string` | yes | — |  |
| `security_enabled` | `bool` | yes | — |  |
| `description` | `string` | no | `null` |  |
| `group_types` | `list(string)` | no | `null` |  |
| `visibility` | `string` | no | `null` |  |
| `is_assignable_to_role` | `bool` | no | `null` |  |
| `membership_rule` | `string` | no | `null` |  |
| `membership_rule_processing_state` | `string` | no | `null` |  |

#### YAML Example

```yaml
entraid_groups:
  admins:
    display_name: "Platform Admins"
    mail_enabled: false
    mail_nickname: "platform-admins"
    security_enabled: true
```

---

### `entraid_oauth2_permission_grants`

**API version:** `Microsoft Graph beta (required for service principal callers)`

Map of OAuth2 delegated permission grants (admin consent) to create via
Microsoft Graph beta API. This is the programmatic equivalent of clicking
"Grant administrator consent" in the Azure Portal.

Uses the /beta endpoint which supports both user and service principal
callers (required for pipeline/automation scenarios).

Requires var.graph_access_token to be set with a token scoped to
https://graph.microsoft.com/.default.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `client_id` | `string` | yes | — |  |
| `resource_id` | `string` | yes | — |  |
| `scope` | `string` | no | `"user_impersonation"` |  |
| `consent_type` | `string` | no | `"AllPrincipals"` |  |
| `principal_id` | `string` | no | `null` |  |

#### YAML Example

```yaml
entraid_oauth2_permission_grants:
  vpn_client_consent:
    client_id: "ref:entraid_service_principals.vpn_client.id"
    resource_id: "ref:entraid_service_principals.vpn_server.id"
    scope: "user_impersonation"
```

---

### `entraid_service_principals`

**API version:** `Microsoft Graph v1.0`

Map of service principals to register in the tenant via Microsoft Graph API.
Creates Enterprise Application registrations from well-known application
(client) IDs. This is the programmatic equivalent of "az ad sp create".

Requires var.graph_access_token to be set with a token scoped to
https://graph.microsoft.com/.default.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `app_id` | `string` | yes | — |  |

#### YAML Example

```yaml
entraid_service_principals:
  azure_vpn:
    app_id: "c632b3df-fb67-4d84-bdcf-b95ad541b5c8"
```

---

### `entraid_users`

**API version:** `Microsoft Graph v1.0`

Map of Entra ID users to create via Microsoft Graph API.
Each map key acts as the for_each identifier.

Requires var.graph_access_token to be set with a token scoped to
https://graph.microsoft.com/.default.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `display_name` | `string` | yes | — |  |
| `mail_nickname` | `string` | yes | — |  |
| `user_principal_name` | `string` | yes | — |  |
| `account_enabled` | `bool` | yes | — |  |
| `password_profile` | `object` | yes | — |  |
| `given_name` | `string` | no | `null` |  |
| `surname` | `string` | no | `null` |  |
| `job_title` | `string` | no | `null` |  |
| `department` | `string` | no | `null` |  |
| `office_location` | `string` | no | `null` |  |
| `city` | `string` | no | `null` |  |
| `country` | `string` | no | `null` |  |
| `state` | `string` | no | `null` |  |
| `postal_code` | `string` | no | `null` |  |
| `street_address` | `string` | no | `null` |  |
| `company_name` | `string` | no | `null` |  |
| `mobile_phone` | `string` | no | `null` |  |
| `preferred_language` | `string` | no | `null` |  |
| `usage_location` | `string` | no | `null` |  |
| `user_type` | `string` | no | `null` |  |
| `employee_id` | `string` | no | `null` |  |
| `employee_type` | `string` | no | `null` |  |
| `other_mails` | `list(string)` | no | `null` |  |

#### YAML Example

```yaml
entraid_users:
  jane:
    display_name: "Jane Doe"
    mail_nickname: "janedoe"
    user_principal_name: "janedoe@contoso.onmicrosoft.com"
    account_enabled: true
    password_profile:
      password: "SecureP@ss123!"
      force_change_password_next_sign_in: true
```

---
