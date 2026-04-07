---
name: tf-import
description: "Import existing Azure resources into Terraform state by discovering them via Azure Resource Graph, generating configuration YAML and import blocks, and verifying with plan. Use when: import existing resources, adopt infrastructure, bring under terraform management, tf_import, import resource group, import storage account, import from subscription, import by tag, import by resource group, discover azure resources, brownfield import, terraform import restful, generate config from azure, reverse engineer azure, onboard existing infra"
argument-hint: "Scope: resource type, resource group name, tag filter, or subscription ID — e.g. 'Microsoft.Storage/storageAccounts in rg-prod', 'tag:environment=production', 'resource group my-rg'"
---

# tf-import

Discover existing Azure resources via Azure Resource Graph, generate Terraform configuration and import blocks, and verify the import produces **no changes** on `terraform plan`.

## When to Use

- You have existing Azure infrastructure deployed outside Terraform and want to bring it under management
- You want to adopt resources from a specific resource group, matching a tag, or of a specific resource type
- You need to generate a configuration YAML from live Azure resources
- You want to import resources into this repo's `rest_resource`-based modules

## Safety Constraints

**CRITICAL — read before proceeding:**

1. **NEVER run `terraform destroy`** at any point during this workflow. Import is a read-and-adopt operation only.
2. **NEVER run `terraform apply` without `-refresh-only`** unless the user explicitly requests it and understands the implications.
3. The goal is `terraform plan` showing **"No changes"** — meaning the generated config perfectly matches the deployed state.
4. If plan shows diffs, fix the configuration — do NOT apply changes to Azure.
5. All state modifications happen via `check_existance = true` (the provider adopts existing resources during apply) — no manual state editing.

## Prerequisites

- Azure CLI logged in: `az account show` must succeed
- `az graph` extension: install with `az extension add --name resource-graph` if missing
- Terraform initialized: `terraform init -backend=false`
- Access token: `export TF_VAR_access_token=$(az account get-access-token --resource https://management.azure.com --query accessToken -o tsv)`
- Import mode: `export TF_VAR_check_existance=true` — enables brownfield adoption of existing resources

## Inputs

| Argument | Required | Description |
|----------|----------|-------------|
| scope | yes | What to import — one of: resource type, resource group name, tag filter, or "all" |
| subscription | no | Target subscription ID (defaults to current `az account show`) |

### Scope formats

| Format | Example | Meaning |
|--------|---------|---------|
| Resource type | `Microsoft.Storage/storageAccounts` | All resources of this type |
| Resource group | `rg:my-resource-group` | All resources in this RG |
| Tag filter | `tag:environment=production` | All resources with this tag |
| Specific resource | `/azure_subscriptions/.../resourceGroups/.../providers/Microsoft.Storage/storageAccounts/mysa` | One resource by full ID |

## Procedure

### Step 1 — Verify prerequisites

Run these checks and fail fast if any are missing:

```bash
# Check Azure CLI login
az account show --query '{subscription:id, tenant:tenantId, name:name}' -o table

# Check resource-graph extension
az extension show --name resource-graph -o table 2>/dev/null || az extension add --name resource-graph

# Set environment
export TF_VAR_access_token=$(az account get-access-token --resource https://management.azure.com --query accessToken -o tsv)
export TF_VAR_subscription_id=$(az account show --query id -o tsv)
export TF_VAR_tenant_id=$(az account show --query tenantId -o tsv)
export TF_VAR_check_existance=true  # Enable brownfield import — adopt existing resources
```

### Step 2 — Discover resources via Azure Resource Graph

Build and execute an ARG query based on the user's scope.

**By resource type:**
```bash
az graph query -q "
  resources
  | where type =~ 'microsoft.storage/storageaccounts'
  | where subscriptionId == '<subscription_id>'
  | project id, name, type, resourceGroup, location, tags, properties
  | order by resourceGroup asc, name asc
" --azure_subscriptions <subscription_id> -o json
```

**By resource group:**
```bash
az graph query -q "
  resources
  | where resourceGroup =~ '<resource_group_name>'
  | where subscriptionId == '<subscription_id>'
  | project id, name, type, resourceGroup, location, tags, properties
  | order by type asc, name asc
" --azure_subscriptions <subscription_id> -o json
```

**By tag:**
```bash
az graph query -q "
  resources
  | where tags['<tag_key>'] == '<tag_value>'
  | where subscriptionId == '<subscription_id>'
  | project id, name, type, resourceGroup, location, tags, properties
  | order by type asc, name asc
" --azure_subscriptions <subscription_id> -o json
```

**By full resource ID:**
```bash
az graph query -q "
  resources
  | where id == '<full_resource_id>'
  | project id, name, type, resourceGroup, location, tags, properties
" -o json
```

Save the results. Present a summary table to the user:

```
## Discovered Resources

| # | Type | Name | Resource Group | Location |
|---|------|------|----------------|----------|
| 1 | Microsoft.Storage/storageAccounts | mysa01 | rg-prod | westeurope |
| 2 | Microsoft.KeyVault/vaults | kv-prod | rg-prod | westeurope |
```

#### Step 2b — Discover role assignments (permissions)

For each discovered resource (and the resource group itself), query role assignments scoped to it. Use the ARG `authorizationresources` table:

```bash
az graph query -q "
  authorizationresources
  | where type =~ 'microsoft.authorization/roleassignments'
  | where properties.scope =~ '<resource_id>'
  | project id, name, properties
  | order by name asc
" --azure_subscriptions <subscription_id> -o json
```

Alternatively, query all role assignments for a resource group scope and its children:
```bash
az graph query -q "
  authorizationresources
  | where type =~ 'microsoft.authorization/roleassignments'
  | where properties.scope startswith '/azure_subscriptions/<sub_id>/resourceGroups/<rg_name>'
  | project id, name,
      scope = tostring(properties.scope),
      roleDefinitionId = tostring(properties.roleDefinitionId),
      principalId = tostring(properties.principalId),
      principalType = tostring(properties.principalType),
      description = tostring(properties.description)
  | order by scope asc, name asc
" --azure_subscriptions <subscription_id> -o json
```

**Filtering rules for role assignments:**
- **Include** assignments where the `principalType` is `ServicePrincipal`, `Group`, or `User` and the role is custom or a well-known built-in role relevant to the resources.
- **Exclude** system-managed assignments (e.g., Azure Policy, Azure Kubernetes Service internal roles) — these are typically created by `principalType = "ServicePrincipal"` with a system-owned `principalId`. If in doubt, include them and let the user review.
- **Exclude** classic administrator assignments (`microsoft.authorization/classicadministrators`).

Present the discovered permissions:

```
## Discovered Role Assignments

| # | Scope | Role Definition | Principal ID | Principal Type |
|---|-------|-----------------|--------------|----------------|
| 1 | /azure_subscriptions/.../providers/Microsoft.KeyVault/vaults/kv-prod | Key Vault Crypto User | aabbccdd-... | ServicePrincipal |
```

#### Step 2c — Discover managed identities on resources

When a resource has an `identity` property in its ARM response (fetched in Step 4), capture:

1. **System-assigned identity**: Note the `principalId` and `tenantId` from `identity.principalId` — this is used for role assignments.
2. **User-assigned identities**: Extract the identity resource IDs from `identity.userAssignedIdentities` — each key is a full ARM resource ID.

For user-assigned identities found on resources:
- Check if the identity itself is already in the discovered resource list
- If not, add it as an additional resource to import (query it via ARG or `az rest`)
- This ensures the identity is under Terraform management alongside the resources that reference it

```bash
# Discover user-assigned identities in the resource group
az graph query -q "
  resources
  | where type =~ 'microsoft.managedidentity/userassignedidentities'
  | where resourceGroup =~ '<rg_name>'
  | where subscriptionId == '<subscription_id>'
  | project id, name, type, resourceGroup, location, tags, properties
" --azure_subscriptions <subscription_id> -o json
```

### Step 3 — Map ARM types to existing modules

For each discovered resource, check whether a matching module exists under `modules/azure/`:

| ARM Type | Module Directory | Status |
|----------|-----------------|--------|
| `Microsoft.Resources/resourceGroups` | `modules/azure/resource_group/` | EXISTS |
| `Microsoft.Storage/storageAccounts` | `modules/azure/storage_account/` | EXISTS |
| `Microsoft.KeyVault/vaults` | `modules/azure/key_vault/` | EXISTS |
| `Microsoft.Network/virtualWans` | `modules/azure/virtual_wan/` | EXISTS |
| `Microsoft.Compute/virtualMachines` | — | **MISSING** |

The mapping from ARM type to module directory follows these conventions:
- `Microsoft.Resources/resourceGroups` → `resource_group` (plural: `azure_resource_groups`)
- `Microsoft.Storage/storageAccounts` → `storage_account` (plural: `azure_storage_accounts`)
- `Microsoft.KeyVault/vaults` → `key_vault` (plural: `azure_key_vaults`)
- `Microsoft.ManagedIdentity/userAssignedIdentities` → `user_assigned_identity` (plural: `azure_user_assigned_identities`)
- `Microsoft.Network/virtualWans` → `virtual_wan` (plural: `azure_virtual_wans`)
- `Microsoft.Network/virtualHubs` → `virtual_hub` (plural: `azure_virtual_hubs`)
- `Microsoft.Network/azureFirewalls` → `azure_firewall` (plural: `azure_firewalls`)
- `Microsoft.Network/firewallPolicies` → `firewall_policy` (plural: `azure_firewall_policies`)
- `Microsoft.Network/connections` → `virtual_network_gateway_connection` (plural: `azure_virtual_network_gateway_connections`) — the ARM type "connections" is too generic; qualified with the parent resource context
- `Microsoft.Authorization/roleAssignments` → `role_assignment` (plural: `azure_role_assignments`) — uses `rest_resource`
- `Microsoft.KeyVault/vaults/keys` → `key_vault_key` (plural: `azure_key_vault_keys`) — uses `rest_operation` (**not importable**)
- General rule: use a descriptive name that gives context about the resource. When the ARM type's last segment is too generic (e.g., `connections`, `endpoints`), qualify it with the parent resource context (e.g., `virtual_network_gateway_connection` instead of `connection`). Convert PascalCase to snake_case.

**Importability by resource type:**
```
grep -E 'resource "rest_(resource|operation)"' modules/azure/<module_name>/main.tf
```
- `rest_resource` → importable
- `rest_operation` → NOT importable (one-shot API call, no state tracking)

**If a module is MISSING:**
- Inform the user: "Module for `<ARM type>` does not exist yet. Use `tf-module` to create it first, then re-run `tf-import`."
- Skip that resource type and continue with the rest.
- Do NOT attempt to create the module as part of the import workflow.

### Step 4 — Fetch full resource properties from ARM

For each resource that has a matching module, fetch the full resource body via the ARM REST API. This gives us the actual property values needed to generate an accurate configuration.

Read the module's `main.tf` to determine the `api_version`:
```bash
grep "api_version" modules/azure/<module_name>/main.tf
```

Then fetch the resource:
```bash
az rest --method GET \
  --url "https://management.azure.com<resource_id>?api-version=<api_version>"
```

Parse the response to extract only the **writable properties** that the module manages (compare against `modules/azure/<module_name>/variables.tf`).

#### Step 4b — Extract identity and metadata from ARM responses

For each resource response, also extract:

1. **Identity block** — if the resource has an `identity` property:
   - `identity.type` → maps to the module's `identity_type` variable (e.g., `SystemAssigned`, `UserAssigned`, `SystemAssigned,UserAssigned`)
   - `identity.userAssignedIdentities` → maps to the module's `identity_user_assigned_identity_ids` variable (list of ARM resource IDs)
   - `identity.principalId` (system-assigned) → record for role assignment generation

2. **Tags** — always capture the full `tags` object even if empty. Tags are part of the writable body for every resource.

3. **SKU / Kind metadata** — capture `sku`, `kind`, `plan`, and similar top-level properties that are common across resource types.

4. **Diagnostic settings** — note that diagnostic settings (`Microsoft.Insights/diagnosticSettings`) are child resources scoped to a parent. If a module for diagnostic settings exists, query them:
   ```bash
   az rest --method GET \
     --url "https://management.azure.com<resource_id>/providers/Microsoft.Insights/diagnosticSettings?api-version=2021-05-01-preview"
   ```
   If no module exists, inform the user that diagnostic settings were found but cannot be imported yet.

5. **Resource locks** — query locks scoped to each resource:
   ```bash
   az rest --method GET \
     --url "https://management.azure.com<resource_id>/providers/Microsoft.Authorization/locks?api-version=2020-05-01"
   ```
   If locks exist but no module for locks is available, inform the user.

### Step 5 — Generate configuration YAML

Create a configuration YAML file at `configurations/import_<scope_name>.yaml`.

For each discovered resource, map the ARM response properties to the module's variable names.

**Property mapping rules — CRITICAL for zero-diff imports:**

The goal is `terraform plan` showing **NO changes**. This means the YAML must set **every attribute whose deployed value differs from the module variable's `default`**. A missing attribute causes the module to use its default, which may differ from the deployed value, producing a plan diff.

1. Read `modules/azure/<module_name>/variables.tf` to get the **complete** list of variables, their types, and their `default` values.
2. Read `modules/azure/<module_name>/main.tf` to understand how variables map to ARM body properties (the `body` local). Pay attention to:
   - Property name mapping (e.g., ARM `properties.supportsHttpsTrafficOnly` → variable `https_traffic_only_enabled`)
   - Conditional inclusion (e.g., `var.tags != null ? { tags = var.tags } : {}`)
   - Nested objects (e.g., `properties.encryption`, `properties.networkAcls`)
3. For **each variable**, find the corresponding ARM property in the fetched resource body.
4. **Compare the ARM value against the variable's `default`:**
   - If the ARM value **differs from the default** → **MUST set it in the YAML**
   - If the ARM value **matches the default** → may omit (but setting it explicitly is safer)
   - If the variable has **no default** (required) → **MUST always set it**
   - If the ARM value is `null`/absent and the variable default is `null` → omit
5. For cross-resource references, use `ref:` syntax where the referenced resource is also being imported.

**Common attributes that MUST be checked (often cause plan diffs when omitted):**

| Attribute Category | Why It Matters |
|-------------------|---------------|
| `tags` | ARM always returns a tags object (even `{}`). If the resource has ANY tags, they must all be in the YAML. |
| `sku_name` / `kind` | Required. Must match ARM exactly (case-sensitive). |
| `https_traffic_only_enabled` | Default is `true` in module. If ARM says `true`, safe to omit. If `false`, MUST set. |
| `minimum_tls_version` | Default is `"TLS1_2"`. If ARM returns `"TLS1_0"`, MUST set. |
| `allow_blob_public_access` | Default is `false`. If ARM says `true`, MUST set. |
| `public_network_access` | Default is `null`. If ARM returns `"Enabled"`, MUST set. |
| `identity_type` | Default is `null`. If resource has a managed identity, MUST set. |
| `network_acls` | Default is `null`. If ARM returns network rules, MUST set the full object. |
| `encryption_*` | Default is `null`. If CMK encryption is configured, MUST set all encryption fields. |

**Example generated YAML (fully populated to match deployed state):**
```yaml
# Auto-generated by tf-import from subscription <subscription_id>
# Source: resource group 'rg-prod'
# Date: <timestamp>
#
# Review this file carefully before importing.
# Every attribute is set to match the deployed ARM state exactly.
# Run: TF_VAR_config_file=configurations/import_rg_prod.yaml terraform plan

azure_resource_groups:
  prod:
    subscription_id: <subscription_id>
    location: westeurope
    tags:
      environment: production
      managed_by: platform-team

azure_storage_accounts:
  sa01:
    subscription_id: <subscription_id>
    resource_group_name: ref:azure_resource_groups.prod.resource_group_name
    location: ref:azure_resource_groups.prod.location
    sku_name: Standard_GRS
    kind: StorageV2
    # --- All attributes below are set because they differ from module defaults
    #     or are present in the ARM response. This ensures zero plan diff.
    https_traffic_only_enabled: true          # matches default — explicit for safety
    minimum_tls_version: "TLS1_2"             # matches default — explicit for safety
    allow_blob_public_access: false           # matches default — explicit for safety
    allow_shared_key_access: true             # ARM returns true, module default is null
    public_network_access: "Enabled"          # ARM returns "Enabled", module default is null
    default_to_oauth_authentication: false    # ARM returns false, module default is null
    allow_cross_tenant_replication: false      # ARM returns false, module default is null
    identity_type: UserAssigned
    identity_user_assigned_identity_ids:
      - ref:azure_user_assigned_identities.sa_identity.id
    network_acls:
      default_action: Allow
      bypass:
        - AzureServices
    tags:
      environment: production
      team: data-platform
```

**Attribute completeness checklist (run for each resource before saving YAML):**
1. Fetch the ARM response: `az rest --method GET --url "https://management.azure.com<id>?api-version=<version>"`
2. For each variable in `modules/azure/<name>/variables.tf`:
   - Find the mapped ARM property (from `main.tf` body local)
   - Read the deployed value from the ARM response
   - Compare with the variable's `default`
   - If different → add to YAML
3. Verify no ARM properties are managed by the module but missing from the YAML

**Present the generated YAML to the user for review before saving.**

### Step 6 — Enable check_existance for import

Instead of generating `import {}` blocks, set the `check_existance` variable to `true`. This tells each module's `rest_resource` to perform a GET before PUT — if the resource already exists in Azure, it is automatically adopted into Terraform state.

```bash
export TF_VAR_check_existance=true
```

This eliminates the need for import blocks entirely. The provider will:
1. Read the resource at its ARM path
2. If found → import it into state (no create call)
3. If not found → create it normally

**Advantages over import blocks:**
- No need to construct complex JSON import IDs
- No need to enumerate writable properties in the import body
- No temporary `import_*.tf` files to create and clean up
- Works automatically for all `rest_resource`-based modules

**Limitation — `rest_operation` modules**: Modules that use `rest_operation` (e.g., `key_vault_key`, `resource_provider_registration`) are one-shot API calls and have no `check_existance` support. These resources cannot be imported via this mechanism. Inform the user and skip them.

### Step 7 — Initialize and plan

```bash
terraform init -backend=false
TF_VAR_check_existance=true terraform plan -var config_file=configurations/import_<scope_name>.yaml
```

**Interpret the plan output:**

| Plan Output | Meaning | Action |
|-------------|---------|--------|
| `0 to add, 0 to change, 0 to destroy` | Config matches deployed state | Unlikely on first run — usually some drift |
| `N to add, 0 to change, 0 to destroy` | Resources will be "created" but `check_existance=true` means existing ones are adopted | Expected — proceed to Step 8 |
| Any line showing `destroy` | **STOP IMMEDIATELY** | Do NOT proceed. Investigate why — likely a config mismatch |

**Note:** With `check_existance = true`, the plan will show resources as "to add" because Terraform doesn't know they already exist until apply time. This is normal — the provider handles the adoption transparently during apply.

#### Step 7a — Fix plan diffs (iterate)

For each diff shown in the plan:

1. Identify which module/resource has the drift
2. Fetch the current value from ARM: `az rest --method GET --url "https://management.azure.com<id>?api-version=<version>"`
3. Compare the ARM value with what the YAML generates
4. Update the YAML to match the ARM value exactly
5. Re-run `terraform plan` — repeat until "No changes" or only imports

**Common diff causes:**

| Diff | Cause | Fix |
|------|-------|-----|
| `tags` mismatch | Extra tags on Azure resource | Add all tags to YAML |
| `sku` different | Wrong SKU value in config | Use exact ARM value (e.g. `Standard_GRS` not `Standard_LRS`) |
| Property present in ARM but absent in config | Optional property has non-default value | Add the property to YAML |
| Nested object differs | Module body structure doesn't match ARM response | Check module's `main.tf` body local for the correct structure |
| Case sensitivity | ARM returns different casing than config | Match ARM casing exactly |

Fix the diff in the yaml and in the terraform  modules if needed to ensure the module's expected config structure matches the ARM response structure. This is critical for achieving a zero-diff plan.

### Step 8 — Execute the import

Once the plan looks correct (resources shown as "to add" are expected):

```bash
TF_VAR_check_existance=true terraform apply -var config_file=configurations/import_<scope_name>.yaml
```

This will:
- For each resource that already exists in Azure: adopt it into Terraform state (GET succeeds → no PUT)
- For resources that don't exist: create them (normal flow)
- NOT destroy any Azure resources

### Step 9 — Verify with final plan

```bash
TF_VAR_check_existance=true terraform plan -var config_file=configurations/import_<scope_name>.yaml
```

**Expected output:** `No changes. Your infrastructure matches the configuration.`

If this succeeds, the configuration YAML and state now manage the imported resources.

If there are still diffs, return to Step 7a and iterate.

**Post-import:** Once all resources are imported and the plan is clean, subsequent runs no longer need `TF_VAR_check_existance=true` — you can manage the resources with the default `check_existance = false` since they are already in state.

### Step 10 — Summary

Print a completion summary:

```
## tf-import: <scope_name>

- Subscription: <subscription_id>
- Resources discovered: <N>
- Resources adopted: <M>
- Resources skipped (no module): <K>
  - <list of skipped ARM types>
- Configuration: configurations/import_<scope_name>.yaml
- Method: check_existance=true (no import blocks needed)
- Final plan: No changes ✅

### Imported Resources
| Key | Type | ARM Resource ID |
|-----|------|-----------------|
| azure_resource_groups.prod | Resource Group | /azure_subscriptions/.../resourcegroups/rg-prod |
| azure_storage_accounts.sa01 | Storage Account | /azure_subscriptions/.../providers/Microsoft.Storage/storageAccounts/mysa01 |
```

## Role Assignment Import Details

Role assignments require special handling because:

1. **The assignment GUID is generated by the module** — the `role_assignment` module uses `random_uuid` to generate the assignment name. During import with `check_existance = true`, the existing role assignment is adopted but the `random_uuid` resource still needs alignment.
2. **Role definition IDs** — ARM returns the full form (`/azure_subscriptions/<sub>/providers/Microsoft.Authorization/roleDefinitions/<guid>`). The YAML can use either the full form or the provider-relative form (`/providers/Microsoft.Authorization/roleDefinitions/<guid>`) — the module normalises both.
3. **Principal IDs for imported identities** — if the principal is a user-assigned identity also being imported, use `ref:azure_user_assigned_identities.<key>.principal_id`. Note that `principal_id` is known-after-apply, so the `ref:` will resolve only at apply time.
4. **System-assigned identity principals** — these `principalId` values come from the resource's `identity` block. Since they are read-only outputs, you cannot use `ref:` — use the literal GUID from the ARM response.

**NOTE**: After the initial apply with `check_existance = true`, the `random_uuid` resource in the role_assignment module will have generated a new UUID that differs from the existing ARM assignment name. Run `terraform state rm 'module.azure_role_assignments["<key>"].random_uuid.role_assignment_name'` and then `terraform import 'module.azure_role_assignments["<key>"].random_uuid.role_assignment_name' <existing_guid>` to align the UUID.

## Resource Group Discovery Shortcut

When importing by resource group, the resource group itself should always be included as the first resource. Query it separately since ARG `resources` table doesn't include resource groups:

```bash
# Get the resource group itself
az group show --name <rg_name> --subscription <subscription_id> -o json

# Then get all resources in it
az graph query -q "
  resources
  | where resourceGroup =~ '<rg_name>'
  | where subscriptionId == '<subscription_id>'
  | project id, name, type, resourceGroup, location, tags
  | order by type asc, name asc
" --azure_subscriptions <subscription_id> -o json
```

## Multi-Subscription Import

When the user specifies multiple azure_subscriptions:
1. Run the discovery (Step 2) against each subscription
2. Merge results, prefixing config keys with a subscription alias to avoid collisions
3. Each resource entry in the YAML includes `subscription_id` explicitly

## Naming Convention for Config Keys

When generating YAML keys for discovered resources, use these rules:
1. Start with the resource name (lowercased, hyphens replaced with underscores)
2. If the name would collide across resource groups, prefix with a shortened RG name
3. Keys must be valid Terraform map keys (alphanumeric + underscores)

Example: resource `my-storage-01` in `rg-prod` → key `my_storage_01`

## Constraints

- **Provider**: Only `LaurentLesle/rest ~> 1.0` — never `azurerm` or `azapi`
- **No destruction**: Never run `terraform destroy` or allow any destroy actions
- **No blind apply**: Never run `terraform apply` (non-import) without user confirmation and a clean plan
- **Module dependency**: Resources can only be imported if a matching module exists in `modules/azure/`. Use `tf-module` to create missing modules first.
- **Config accuracy**: The generated YAML must produce a plan with NO changes — iterate until achieved
- **Permissions completeness**: Always discover and include role assignments scoped to imported resources. Missing RBAC assignments can cause operational issues.
- **Metadata completeness**: Always capture tags, identity blocks, and SKU/kind from ARM responses. Missing metadata will cause plan diffs.
- **State safety**: Only modify state via `terraform import` or `import {}` blocks

## See Also

- Patterns: [`.github/patterns/rest-provider-patterns.md`](../../patterns/rest-provider-patterns.md) — critical patterns for import body specificity, output_attrs, and drift resolution
- Skill: `tf-module` — create new modules for resource types that don't have one yet
- Skill: `tf-fix` — audit and fix existing modules against the latest API spec
- Skill: `tf-test` — run plan tests against example configurations
