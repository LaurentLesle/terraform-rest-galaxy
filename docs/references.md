# Cross-References and External Resources

galaxy resolves `ref:` expressions at plan time, letting YAML values reference outputs
from other resources in the same config, from pre-existing infrastructure declared
as `externals`, from other Terraform state files, or from the calling identity.

---

## `ref:` Expression Syntax

```
ref:<path>
ref:<path>|<default>
"prefix-${ref:<path>}-suffix"
```

| Form | Description |
|------|-------------|
| `ref:a.b.c` | Resolves `a.b.c` from the reference context — fails if missing |
| `ref:a.b.c\|fallback` | Same, but returns `fallback` if the path is missing or null |
| `"${ref:a.b.c}"` | Embeds the resolved value inside a string |

The reference context contains everything declared in the same YAML config, plus
`externals`, `remote_states`, and `caller`. Resolution is lazy and ordered by
dependency layer — a resource can only reference resources at an earlier or equal layer.

---

## Reference Sources

### 1. Same-config resources

Reference any output attribute of another resource declared in the same YAML file:

```
ref:<resource_type>.<instance_key>.<output_attribute>
```

The `resource_type` matches the YAML top-level key (e.g. `azure_resource_groups`).
The `instance_key` is the map key you chose (e.g. `app`).
The `output_attribute` is any output exposed by the module (e.g. `resource_group_name`, `id`, `location`).

**Common outputs available on every Azure resource:**

| Attribute | Description |
|-----------|-------------|
| `id` | Full ARM resource ID |
| `name` | Resource name |
| `location` | Azure region |
| `resource_group_name` | Containing resource group name |

---

### 2. `externals` — pre-existing resources

Pre-existing infrastructure not managed by this Terraform config. Declared under
the `externals` top-level key. Attributes are validated against the live API at plan
time (GET call) so you get an early error if the resource doesn't exist.

```
ref:externals.<category>.<instance_key>.<attribute>
```

---

### 3. `remote_states` — outputs from another state

References outputs from other Terraform state files stored in the same Azure Storage
backend. Declared inline in `terraform_backend.remote_states`.

```
ref:remote_states.<logical_name>.<outputs_path>
```

---

### 4. `caller` — identity of the applying principal

Populated automatically by `tf.sh` from the current Azure CLI session.

```
ref:caller.object_id        # Object ID of the current user/SP
ref:caller.subscription_id  # Current subscription ID
```

---

## Within-Provider Cross-References (Azure → Azure)

The most common pattern: chain resources within the same provider by referencing
outputs from an earlier resource.

### Resource group → everything else

Every Azure resource can inherit `resource_group_name`, `location`, and `tags`
from its resource group:

```yaml
azure_resource_groups:
  app:
    resource_group_name: rg-myapp-prod
    location: westeurope
    tags:
      environment: production

azure_storage_accounts:
  data:
    resource_group_name: ref:azure_resource_groups.app.resource_group_name
    location:            ref:azure_resource_groups.app.location
    tags:                ref:azure_resource_groups.app.tags
    account_name: stmyappdata001
    sku_name: Standard_LRS
    kind: StorageV2
```

### Storage account with Customer-Managed Key

A chain spanning resource group → managed identity → key vault → key → role assignment → storage account.
Each resource references outputs from earlier ones:

```yaml
default_location: westeurope

azure_resource_groups:
  cmk:
    resource_group_name: rg-cmk-prod

azure_user_assigned_identities:
  storage:
    resource_group_name: ref:azure_resource_groups.cmk.resource_group_name
    identity_name: id-storage-cmk
    location: ref:azure_resource_groups.cmk.location

azure_key_vaults:
  cmk:
    resource_group_name: ref:azure_resource_groups.cmk.resource_group_name
    vault_name: kv-cmk-prod
    location: ref:azure_resource_groups.cmk.location
    enable_rbac_authorization: true
    enable_purge_protection: true

azure_key_vault_keys:
  storage:
    resource_group_name: ref:azure_resource_groups.cmk.resource_group_name
    vault_name: ref:azure_key_vaults.cmk.name        # ← references key vault output
    key_name: cmk-storage
    key_type: RSA
    key_size: 2048

azure_role_assignments:
  storage_crypto_user:
    scope:              ref:azure_key_vaults.cmk.id  # ← key vault ARM ID
    role_definition_id: /providers/Microsoft.Authorization/roleDefinitions/12338af0-0e69-4776-bea7-57ae8d297424
    principal_id:       ref:azure_user_assigned_identities.storage.principal_id
    principal_type: ServicePrincipal

azure_storage_accounts:
  cmk:
    resource_group_name: ref:azure_resource_groups.cmk.resource_group_name
    account_name: sacmkprod001
    location: ref:azure_resource_groups.cmk.location
    sku_name: Standard_LRS
    kind: StorageV2
    identity_type: UserAssigned
    identity_user_assigned_identity_ids:
      - ref:azure_user_assigned_identities.storage.id       # ← UAI ARM ID
    encryption_key_source:   Microsoft.Keyvault
    encryption_key_vault_uri: ref:azure_key_vaults.cmk.vault_uri   # ← vault URI
    encryption_key_name:      ref:azure_key_vault_keys.storage.name # ← key name
    encryption_identity:      ref:azure_user_assigned_identities.storage.id
```

### VNet peering (bidirectional)

Both peerings reference the VNet IDs from the same config:

```yaml
azure_virtual_networks:
  hub:
    resource_group_name: rg-hub
    virtual_network_name: vnet-hub
    address_space: ["10.0.0.0/16"]
    location: westeurope
  spoke:
    resource_group_name: rg-spoke
    virtual_network_name: vnet-spoke
    address_space: ["10.1.0.0/16"]
    location: westeurope

azure_virtual_network_peerings:
  hub_to_spoke:
    resource_group_name:      ref:azure_virtual_networks.hub.resource_group_name
    virtual_network_name:     ref:azure_virtual_networks.hub.name
    remote_virtual_network_id: ref:azure_virtual_networks.spoke.id
    allow_forwarded_traffic: true
  spoke_to_hub:
    resource_group_name:      ref:azure_virtual_networks.spoke.resource_group_name
    virtual_network_name:     ref:azure_virtual_networks.spoke.name
    remote_virtual_network_id: ref:azure_virtual_networks.hub.id
    allow_forwarded_traffic: true
```

---

## Cross-Provider References (Azure ↔ Entra ID ↔ GitHub)

Resources from different providers can freely reference each other.

### Entra ID group → Azure role assignment

Create a group and immediately assign it a role on an Azure resource:

```yaml
azure_resource_groups:
  data:
    resource_group_name: rg-data-prod
    location: westeurope

azure_storage_accounts:
  data:
    resource_group_name: ref:azure_resource_groups.data.resource_group_name
    account_name: stdataprod001
    sku_name: Standard_LRS
    kind: StorageV2
    location: ref:azure_resource_groups.data.location

entraid_groups:
  blob_contributors:
    display_name: tf-blob-contributors
    mail_enabled: false
    mail_nickname: tf-blob-contributors
    security_enabled: true

azure_role_assignments:
  group_blob_contributor:
    scope:              ref:azure_storage_accounts.data.id  # ← Azure storage ID
    role_definition_id: /providers/Microsoft.Authorization/roleDefinitions/ba92f5b4-2d11-453d-a403-e96b0029c9fe
    principal_id:       ref:entraid_groups.blob_contributors.id  # ← Entra group object ID
    principal_type: Group
```

### Azure managed identity → GitHub Actions OIDC → GitHub secrets

Create a managed identity for GitHub Actions, federate it with GitHub OIDC,
and write the resulting client ID and tenant into GitHub repository secrets
— all in one config:

```yaml
azure_resource_groups:
  cicd:
    resource_group_name: rg-github-oidc
    location: westeurope

azure_user_assigned_identities:
  github_actions:
    resource_group_name: ref:azure_resource_groups.cicd.resource_group_name
    identity_name: id-github-actions
    location: ref:azure_resource_groups.cicd.location

azure_federated_identity_credentials:
  main_branch:
    resource_group_name:       ref:azure_resource_groups.cicd.resource_group_name
    identity_name:             ref:azure_user_assigned_identities.github_actions.name
    federated_credential_name: github-oidc-main
    issuer:  "https://token.actions.githubusercontent.com"
    subject: "repo:my-org/my-repo:ref:refs/heads/main"
    audiences:
      - "api://AzureADTokenExchange"
  pull_request:
    resource_group_name:       ref:azure_resource_groups.cicd.resource_group_name
    identity_name:             ref:azure_user_assigned_identities.github_actions.name
    federated_credential_name: github-oidc-pr
    issuer:  "https://token.actions.githubusercontent.com"
    subject: "repo:my-org/my-repo:pull_request"
    audiences:
      - "api://AzureADTokenExchange"

azure_role_assignments:
  cicd_contributor:
    scope:              ref:caller.subscription_id|/subscriptions/00000000-0000-0000-0000-000000000000
    role_definition_id: /providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c
    principal_id:       ref:azure_user_assigned_identities.github_actions.principal_id
    principal_type: ServicePrincipal

# Write the OIDC credentials directly into GitHub secrets
github_repository_secrets:
  client_id:
    owner: my-org
    repo: my-repo
    secret_name: AZURE_CLIENT_ID
    plaintext_value: ref:azure_user_assigned_identities.github_actions.client_id  # ← from Azure
  tenant_id:
    owner: my-org
    repo: my-repo
    secret_name: AZURE_TENANT_ID
    plaintext_value: ref:azure_user_assigned_identities.github_actions.tenant_id  # ← from Azure
  subscription_id:
    owner: my-org
    repo: my-repo
    secret_name: AZURE_SUBSCRIPTION_ID
    plaintext_value: ref:caller.subscription_id                                    # ← from CLI session
```

---

## String Interpolation

When the value must be embedded in a larger string, use `${ref:...}`:

```yaml
azure_role_assignments:
  aks_admin:
    # Build the full role definition ID dynamically from the caller's subscription
    role_definition_id: "/subscriptions/${ref:caller.subscription_id}/providers/Microsoft.Authorization/roleDefinitions/4d97b98b-1d4f-4787-a291-c67834d212e7"

azure_managed_clusters:
  aks:
    # Embed tenant ID into an OIDC URL
    oidc_issuer_url: "https://login.microsoftonline.com/${ref:externals.azure_tenants.primary.tenant_id}/v2.0"
```

---

## `ref:` with Default Values

Use the `|` separator to provide a fallback when the reference path may not exist:

```yaml
azure_storage_accounts:
  data:
    # Use the default location if the resource group location is null
    location: ref:azure_resource_groups.app.location|westeurope
    # Use an explicit subscription if the external reference is absent
    subscription_id: ref:externals.azure_subscriptions.prod.subscription_id|00000000-0000-0000-0000-000000000000
```

---

## `externals` — Referencing Pre-Existing Resources

Use `externals` to bring data about resources that exist in Azure (or GitHub)
but are **not managed** by this Terraform config. Attributes are validated via a
live API GET call at plan time.

### Syntax

```yaml
externals:
  <category>:
    <instance_key>:
      <attribute>: <value>
      _exported_attributes: ["*"]   # expose all returned attributes to ref:
      # or:
      _exported_attributes: [id, location, tenant_id]  # expose only these
```

The `<category>` must match an entry in `externals_schema.yaml`
(e.g. `azure_resource_groups`, `azure_virtual_networks`, `entraid_groups`).

### Reference an existing tenant

```yaml
externals:
  azure_tenants:
    corp:
      tenant_id: "4fcc1d67-2ccc-4e50-99c7-93a41aecbca3"
      _exported_attributes: ["*"]

azure_billing_associated_tenants:
  corp:
    billing_account_name: ref:externals.azure_billing_accounts.main.billing_account_name
    tenant_id:            ref:externals.azure_tenants.corp.tenant_id   # ← validated at plan time
    display_name: "Corp Engineering"
```

### Reference existing hub VNet in a spoke deployment

You manage the spoke but the hub already exists in another subscription:

```yaml
externals:
  azure_virtual_networks:
    hub:
      subscription_id:    "11111111-1111-1111-1111-111111111111"
      resource_group_name: rg-hub
      virtual_network_name: vnet-hub
      _exported_attributes: [id, location]

azure_virtual_network_peerings:
  spoke_to_hub:
    resource_group_name:       ref:azure_resource_groups.spoke.resource_group_name
    virtual_network_name:      ref:azure_virtual_networks.spoke.name
    remote_virtual_network_id: ref:externals.azure_virtual_networks.hub.id  # ← live GET-validated
```

### Reference an existing GitHub organization

```yaml
externals:
  github_organizations:
    acme:
      org_name: "acme-corp"
      business_id: "MDEwOk9yZ2FuaXphdGlvbjE="
      _exported_attributes: ["*"]

github_runner_groups:
  platform:
    organization: ref:externals.github_organizations.acme.org_name
    name: platform-runners
```

### Reference Azure role definitions by name

Use the built-in `azure_role_definitions` external category to look up a role
by display name instead of hardcoding its GUID:

```yaml
externals:
  azure_role_definitions:
    contributor:
      role_name: "Contributor"
      _exported_attributes: ["*"]

azure_role_assignments:
  sp_contributor:
    scope:              ref:azure_resource_groups.app.id
    role_definition_id: ref:externals.azure_role_definitions.contributor.id
    principal_id:       ref:azure_user_assigned_identities.app.principal_id
    principal_type: ServicePrincipal
```

### Static externals (no live validation)

When the resource type is not in `externals_schema.yaml` (e.g. custom or unsupported),
supply a `_schema` block to bypass validation, or omit `_exported_attributes` to treat
values as plain static data:

```yaml
externals:
  azure_arc_servers:
    edge_node_01:
      id: /subscriptions/00000000-.../resourceGroups/rg-edge/providers/Microsoft.HybridCompute/machines/edge-node-01
      _schema:
        api_version: "2025-01-13"

azure_arc_kubernetes_extensions:
  monitor:
    resource_group_name: rg-edge
    cluster_name: ref:externals.azure_arc_servers.edge_node_01.id  # ← static, no GET
```

---

## `remote_states` — References Across State Boundaries

When infrastructure is split across multiple YAML configs (each with its own state file),
use `remote_states` to reference outputs from upstream states.

### Declare remote states in `terraform_backend`

```yaml
terraform_backend:
  type: azurerm
  resource_group_name: rg-terraform-state
  storage_account_name: stterraformstate001
  container_name: tfstate
  key: workload.tfstate
  remote_states:
    launchpad:
      key: launchpad.tfstate    # logical name → state key in the same container
    identity:
      key: identity.tfstate
```

### Reference remote state outputs

Remote state outputs are accessed under `ref:remote_states.<name>.<output_path>`.
The path mirrors the output structure of the upstream config:

```yaml
azure_virtual_network_peerings:
  spoke_to_hub:
    resource_group_name:       ref:azure_resource_groups.workload.resource_group_name
    virtual_network_name:      ref:azure_virtual_networks.workload.name
    # Reference hub VNet ID from the launchpad state
    remote_virtual_network_id: ref:remote_states.launchpad.azure_values.azure_virtual_networks.hub.id

azure_private_endpoints:
  storage:
    resource_group_name: ref:azure_resource_groups.workload.resource_group_name
    location:            ref:azure_resource_groups.workload.location
    # Subnet in the hub VNet from launchpad state
    subnet_id: ref:remote_states.launchpad.azure_values.azure_virtual_networks.hub.subnet_ids.snet-private-endpoints
    private_connection_resource_id: ref:azure_storage_accounts.data.id
    group_ids:
      - blob
```

### Expose outputs for downstream configs

For your config's outputs to be available to other configs via `remote_states`,
they must be exported as Terraform outputs. galaxy automatically exports a
structured `azure_values` output containing all managed resource outputs.

```
ref:remote_states.<name>.azure_values.azure_resource_groups.<key>.resource_group_name
ref:remote_states.<name>.azure_values.azure_virtual_networks.<key>.id
ref:remote_states.<name>.azure_values.azure_storage_accounts.<key>.id
```

---

## `caller` — Identity of the Applying Principal

Populated automatically by `tf.sh` from the current Azure CLI session.
Useful for role assignments and OIDC subjects without hardcoding IDs.

```yaml
azure_role_assignments:
  # Grant the current operator Contributor on the subscription
  operator_contributor:
    scope:              "/subscriptions/${ref:caller.subscription_id}"
    role_definition_id: /providers/Microsoft.Authorization/roleDefinitions/b24988ac-6180-42a0-ab88-20f7382dd24c
    principal_id:       ref:caller.object_id
    principal_type: User

azure_key_vaults:
  ops:
    resource_group_name: rg-ops
    vault_name: kv-ops
    location: westeurope
    # Grant the current operator access to key vault secrets
    access_policies:
      - tenant_id:  ref:externals.azure_tenants.corp.tenant_id
        object_id:  ref:caller.object_id
        secret_permissions: ["Get", "List", "Set"]
```

---

## `_tenant` — Multi-Tenant Deployments

`_tenant` is an optional attribute available on most Azure resources. It routes the
ARM API call for that specific resource through a bearer token acquired for a
**different tenant** than the one the caller authenticated to. Omit it entirely in
single-tenant deployments.

### When to use it

| Scenario | Use `_tenant` |
|----------|:---:|
| All resources in your own tenant | No |
| Managing resources in a partner or customer tenant | Yes |
| Billing account operations in another tenant's billing scope | Yes |
| Validating `externals` that live in another tenant | Yes |

### How it works

1. Acquire an ARM token for each target tenant and pass them in `arm_tenant_tokens`:

```bash
export TF_VAR_arm_tenant_tokens="{
  \"<target-tenant-id>\": \"$(az account get-access-token \
    --resource https://management.azure.com \
    --tenant <target-tenant-id> \
    --query accessToken -o tsv)\"
}"
```

2. Set `_tenant: <target-tenant-id>` on each resource that belongs to that tenant.
   galaxy substitutes the matching token into the `Authorization` header for that
   resource's API calls. All other resources continue to use the default token.

### Example — resources in a partner tenant

Your automation runs in **tenant A** but needs to create resources in **tenant B**:

```yaml
externals:
  azure_tenants:
    tenant_b:
      tenant_id: "bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb"
      _exported_attributes: ["*"]

# New subscription is created under tenant B's billing account.
# The ARM call must be authenticated with tenant B's token.
azure_subscriptions:
  partner_platform:
    display_name: Partner-Platform
    billing_scope: /providers/Microsoft.Billing/billingAccounts/...
    workload: Production
    _tenant: ref:externals.azure_tenants.tenant_b.tenant_id  # ← cross-tenant ARM call

# Resources inside the new subscription also target tenant B.
azure_resource_groups:
  platform:
    subscription_id: ref:azure_subscriptions.partner_platform.subscription_id
    resource_group_name: rg-platform
    location: westeurope
    _tenant: ref:externals.azure_tenants.tenant_b.tenant_id  # ← cross-tenant ARM call

azure_user_assigned_identities:
  automation:
    subscription_id: ref:azure_subscriptions.partner_platform.subscription_id
    resource_group_name: ref:azure_resource_groups.platform.resource_group_name
    identity_name: id-automation
    location: westeurope
    _tenant: ref:externals.azure_tenants.tenant_b.tenant_id  # ← cross-tenant ARM call
```

### Example — cross-tenant billing operations

A common pattern: the billing account lives in a separate **billing tenant**,
but the resources being provisioned land in a **target tenant**. Each resource
declares which tenant its API call should be authenticated against:

```yaml
externals:
  azure_tenants:
    billing:
      tenant_id: "aaaa-billing-tenant-id"
      _exported_attributes: ["*"]
    target:
      tenant_id: "bbbb-target-tenant-id"
      _exported_attributes: ["*"]
  azure_billing_accounts:
    main:
      billing_account_name: "01c4287d-..._2019-05-31"
      _tenant: ref:externals.azure_tenants.billing.tenant_id  # ← validates via billing tenant
      _exported_attributes: ["*"]

# Associate the target tenant with the billing account — billing tenant authenticates
azure_billing_associated_tenants:
  target:
    billing_account_name: ref:externals.azure_billing_accounts.main.billing_account_name
    tenant_id:            ref:externals.azure_tenants.target.tenant_id
    display_name: "Target Engineering"
    _tenant: ref:externals.azure_tenants.billing.tenant_id  # ← billing tenant API call

# Create a subscription in the target tenant — billing tenant authenticates
azure_subscriptions:
  platform:
    display_name: Target-Platform
    billing_scope: /providers/Microsoft.Billing/billingAccounts/.../invoiceSections/...
    workload: Production
    subscription_tenant_id: ref:externals.azure_tenants.target.tenant_id
    _tenant: ref:externals.azure_tenants.billing.tenant_id  # ← billing tenant API call

# Resources inside the new subscription — target tenant authenticates
azure_resource_groups:
  platform:
    subscription_id: ref:azure_subscriptions.platform.subscription_id
    resource_group_name: rg-platform
    location: westeurope
    _tenant: ref:externals.azure_tenants.target.tenant_id  # ← target tenant API call
```

> **Note:** `_tenant` only affects the ARM bearer token used for that resource's API
> calls. It does not change the subscription context or any other attribute. Every
> resource that needs to operate in a foreign tenant must declare `_tenant`
> individually.

