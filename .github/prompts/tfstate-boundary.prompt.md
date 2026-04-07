---
description: "Set up or migrate Terraform state boundaries. Reads backend config from the YAML config's terraform_backend section and runs init/plan/apply with the correct -backend-config flags. Triggers: tfstate, state boundary, backend setup, migrate state, init backend, azure storage backend"
mode: "agent"
tools: ["terminal", "read", "edit", "todo"]
---

# tfstate-boundary

Manage Terraform state boundaries using backend configuration declared in YAML config files.

## Arguments

- `$input` — the YAML config file to operate on (e.g. `configurations/k8s_arc_enrollment.yaml`), or `bootstrap` to set up the state storage account itself, or `status` to show all configured backends.

## YAML Backend Schema

Each configuration YAML can include a `terraform_backend` section that declares where its state lives. This metadata is NOT consumed by Terraform directly — this prompt reads it and translates it into `-backend-config` CLI flags.

**SAFETY RULE**: `terraform_backend` is **read-only metadata**. The resources it references (resource group, storage account) must NEVER be managed by the same configuration. Preconditions in `azure_resource_groups.tf` and `azure_storage_accounts.tf` enforce this at plan time. Bootstrap (00-bootstrap) MUST always use `type: local` because it creates the backend storage account itself.

```yaml
# ── State backend (read by /tfstate-boundary prompt) ─────────────────────────
terraform_backend:
  type: azurerm                          # azurerm | local | s3
  key: k8s-arc-enrollment.tfstate        # blob name / state file key
  # Storage account details (from 00-bootstrap output or manual):
  resource_group_name: rg-terraform-state
  storage_account_name: stterraformstate001
  container_name: tfstate
  use_azuread_auth: true
  # Optional — cross-state dependencies:
  remote_states:
    identity:
      key: identity.tfstate
    networking:
      key: networking.tfstate
```

### Supported fields

| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| `type` | yes | — | Backend type: `azurerm`, `local`, or `s3` |
| `key` | yes | — | State file key (blob name for azurerm, file path for local) |
| `resource_group_name` | azurerm | — | RG containing the storage account |
| `storage_account_name` | azurerm | — | Storage account name |
| `container_name` | azurerm | `tfstate` | Blob container name |
| `use_azuread_auth` | azurerm | `true` | Use Entra ID auth (no shared keys) |
| `remote_states` | no | `{}` | Map of upstream state dependencies (name → key) |
| `subscription_id` | azurerm | — | Override subscription for backend (if different from target) |

### Minimal example (local state for dev)

```yaml
terraform_backend:
  type: local
  key: k8s-arc-enrollment.tfstate
```

## Procedure

### 1. Parse the YAML backend config

Read the target YAML config file. Extract the `terraform_backend` section. If absent, inform the user and offer to add one.

### 2. Determine the operation

Based on `$input`:

- **`bootstrap`** → Apply `configurations/00-bootstrap/config.yaml` with `-backend=false` to create the state storage account. Then show the `terraform_backend` snippet for other configs to reference.
- **A config file path** → Run `terraform init` with the right backend flags, then `terraform plan`.
- **`status`** → Scan all `configurations/*.yaml` for `terraform_backend` sections and display a summary table.
- **`migrate <config>`** → Migrate existing local state to remote backend.

### 3. Rewrite `backend.tf` and run init

Before running `terraform init`, **rewrite `backend.tf`** to match the YAML config's `terraform_backend.type`. This avoids the deprecated `-state` flag and ensures the backend type is correct.

**For `local` backend:**

1. Write to `backend.tf`:
   ```hcl
   terraform {
     backend "local" {}
   }
   ```
2. Run init:
   ```bash
   terraform init -reconfigure \
     -backend-config="path=.tfstate/<key>"
   ```

**For `azurerm` backend:**

1. Write to `backend.tf`:
   ```hcl
   terraform {
     backend "azurerm" {}
   }
   ```
2. Run init:
   ```bash
   terraform init -reconfigure \
     -backend-config="resource_group_name=<resource_group_name>" \
     -backend-config="storage_account_name=<storage_account_name>" \
     -backend-config="container_name=<container_name>" \
     -backend-config="key=<key>" \
     -backend-config="use_azuread_auth=<use_azuread_auth>"
   ```

**For migration (local → azurerm):**

1. Write `backend "azurerm" {}` to `backend.tf`
2. Run:
   ```bash
   terraform init -migrate-state \
     -backend-config="resource_group_name=..." \
     -backend-config="storage_account_name=..." \
     -backend-config="container_name=..." \
     -backend-config="key=..." \
     -backend-config="use_azuread_auth=..."
   ```

**IMPORTANT**: The `-state` flag on plan/apply is deprecated. Always use `-backend-config="path=..."` during init for local backends instead.

### 4. Handle remote state dependencies

If `terraform_backend.remote_states` is defined, generate `-var` flags to pass `remote_state_backend` and `remote_state_keys`:

```bash
terraform plan \
  -var="config_file=<config_path>" \
  -var='remote_state_backend={"resource_group_name":"rg-terraform-state","storage_account_name":"stterraformstate001","container_name":"tfstate","use_azuread_auth":true}' \
  -var='remote_state_keys={"identity":"identity.tfstate","networking":"networking.tfstate"}'
```

### 5. Token acquisition

Before running terraform commands, acquire the necessary tokens based on the YAML config:

```bash
export TF_VAR_azure_access_token=$(az account get-access-token \
  --resource https://management.azure.com --query accessToken -o tsv)
export TF_VAR_subscription_id=$(az account show --query id -o tsv)
```

If the config contains `entraid_*` resources, also acquire:
```bash
export TF_VAR_graph_access_token=$(az account get-access-token \
  --resource https://graph.microsoft.com --query accessToken -o tsv)
```

### 6. Summary

After execution, display:
- Backend type and key
- Remote state dependencies resolved
- Plan summary (N to add, N to change, N to destroy)

## Bootstrap procedure

When `$input` is `bootstrap`:

1. Check if `configurations/00-bootstrap/config.yaml` exists. If not, create it using the template from `docs/design-multi-state.md`.
2. **CRITICAL**: Verify `terraform_backend.type` is `local`. Bootstrap must NEVER use `azurerm` — it creates the very storage account that other configs use as their backend. Using azurerm here creates a circular dependency where destroying bootstrap would delete all state.
3. Write `backend "local" {}` to `backend.tf`, then run:
   ```bash
   terraform init -reconfigure \
     -backend-config="path=.tfstate/bootstrap.tfstate"
   terraform apply -var="config_file=configurations/00-bootstrap/config.yaml"
   ```
3. After apply, extract the storage account name from outputs and display the `terraform_backend` block for other configs.
4. Remind the user to:
   - Create the `tfstate` blob container
   - Assign `Storage Blob Data Contributor` to operators/CI identities
   - Add `terraform_backend` to their YAML configs

## Status procedure

When `$input` is `status`:

1. Scan `configurations/*.yaml` and `configurations/*/config.yaml`
2. For each file with a `terraform_backend` section, extract type, key, and remote_states
3. Display a summary table:

```
| Config                          | Backend  | Key                          | Dependencies       |
|---------------------------------|----------|------------------------------|--------------------|
| 00-bootstrap/config.yaml       | local    | bootstrap.tfstate            | —                  |
| k8s_arc_enrollment.yaml        | azurerm  | k8s-arc-enrollment.tfstate   | identity           |
| final_config.yaml              | azurerm  | networking.tfstate           | identity           |
| entraid_group_storage_rbac.yaml| azurerm  | entraid-rbac.tfstate         | —                  |
```
