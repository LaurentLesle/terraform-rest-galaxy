# Design: Multi-State Support with Azure Storage Backend

## Problem

Today, this repository operates as a **single root module** with one `terraform.tfstate`. All resources across all YAML configurations share that state. This creates problems as the infrastructure grows:

- **Blast radius** — a bad plan on networking can affect identity resources
- **Lock contention** — only one `terraform apply` at a time across all domains
- **Permission coupling** — the operator needs tokens for ARM + Graph + GitHub even when only modifying networking
- **State size** — a single growing state slows plan/apply cycles

## Design Goals

1. Split state by **domain** (logical grouping), not by layer
2. Allow cross-state references via the existing `ref:remote_states.*` mechanism
3. Support **local** state (dev/CI) and **Azure Storage** backend (production) with the same configs
4. No changes to existing YAML config files — the split is purely an orchestration concern
5. Keep the single root module (HCL stays in one place); the YAML config + backend define the state boundary

---

## Architecture

### State Partitioning Strategy

Each YAML configuration file already represents a logical domain. The state boundary = the config file:

```
configurations/
  k8s_arc_enrollment.yaml      → tfstate: k8s-arc-enrollment
  final_config.yaml            → tfstate: acme-networking
  storage_account_cmk.yaml     → tfstate: storage-cmk
  entraid_group_storage_rbac.yaml → tfstate: entraid-rbac
```

For larger deployments, a single YAML can be split into multiple files per domain:

```
configurations/
  01-identity/
    config.yaml                → tfstate: identity
  02-networking/
    config.yaml                → tfstate: networking
  03-compute/
    config.yaml                → tfstate: compute
  04-k8s/
    config.yaml                → tfstate: k8s-arc
```

### YAML-Declared Backend (primary approach)

Each YAML config declares its own backend in a `terraform_backend` section.
This is **read-only metadata for tooling** — Terraform cannot read it natively.
The `/tfstate-boundary` prompt (or a CI script) reads this section and translates
it into the appropriate `-backend-config` CLI flags.

> **SAFETY RULE**: The `terraform_backend` section is read-only. The resources
> it references (resource group, storage account) must **never** be managed by
> the same configuration. Preconditions on `module.azure_resource_groups` and
> `module.azure_storage_accounts` enforce this — `terraform plan` will fail if
> any managed resource overlaps with the backend.
>
> **Bootstrap exception**: `00-bootstrap` creates the state storage account
> and MUST always use `type: local`. It must never be migrated to `type: azurerm`
> pointing at the same storage it creates.

```yaml
# ── State backend (read by /tfstate-boundary prompt) ─────────────────────────
terraform_backend:
  type: azurerm                          # azurerm | local
  key: k8s-arc-enrollment.tfstate        # blob name / state file key
  resource_group_name: rg-terraform-state
  storage_account_name: stterraformstate001
  container_name: tfstate
  use_azuread_auth: true
  # Cross-state dependencies — upstream states this config needs refs into:
  remote_states:
    identity:
      key: identity.tfstate
    networking:
      key: networking.tfstate
```

**Schema:**

| Field | Required | Default | Description |
|-------|----------|---------|-------------|
| `type` | yes | — | `azurerm` or `local` |
| `key` | yes | — | State file key (blob name for azurerm) |
| `resource_group_name` | azurerm | — | RG containing the state storage account |
| `storage_account_name` | azurerm | — | Storage account name |
| `container_name` | azurerm | `tfstate` | Blob container name |
| `use_azuread_auth` | azurerm | `true` | Use Entra ID auth (recommended, no shared keys) |
| `subscription_id` | azurerm | — | Override subscription for backend storage |
| `remote_states` | no | `{}` | Map of dependency name → `{ key }` |

**Local dev override:**

```yaml
terraform_backend:
  type: local
  key: k8s-arc-enrollment.tfstate
```

When `type: local`, the tooling runs `terraform init -backend=false` and uses
`-state=.tfstate/<key>` on plan/apply.

### How Tooling Translates YAML → CLI

The `/tfstate-boundary` prompt reads `terraform_backend` and generates:

```bash
# For type: azurerm
terraform init -reconfigure \
  -backend-config="resource_group_name=rg-terraform-state" \
  -backend-config="storage_account_name=stterraformstate001" \
  -backend-config="container_name=tfstate" \
  -backend-config="key=k8s-arc-enrollment.tfstate" \
  -backend-config="use_azuread_auth=true"

# For type: local
terraform init -backend=false
```

### Backend Block in Root Module

A new `backend.tf` file with a partial (empty) configuration:

```hcl
# backend.tf
terraform {
  backend "azurerm" {}
}
```

When using local state (default for dev), init with `-backend=false` (as today).
When using Azure Storage, the YAML's `terraform_backend` fields become `-backend-config` flags.

### Cross-State References

The existing `remote_states` variable + `ref:remote_states.*` already solves this. The orchestrator passes outputs from upstream states as inputs to downstream ones.

**Pattern: data source approach (recommended for Azure Storage backend)**

Add an optional `remote_state_sources.tf`:

```hcl
# remote_state_sources.tf — uncomment the states you need

# data "terraform_remote_state" "identity" {
#   backend = "azurerm"
#   config = {
#     resource_group_name  = "rg-terraform-state"
#     storage_account_name = "stterraformstate001"
#     container_name       = "tfstate"
#     key                  = "identity.tfstate"
#     use_azuread_auth     = true
#   }
# }

variable "remote_state_backend" {
  type = object({
    resource_group_name  = string
    storage_account_name = string
    container_name       = string
    use_azuread_auth     = optional(bool, true)
  })
  default     = null
  description = "Azure Storage backend config for remote state lookups. null = no remote states."
}

variable "remote_state_keys" {
  type        = map(string)
  default     = {}
  description = <<-EOT
    Map of logical name → state key for remote state data sources.
    Example: { identity = "identity.tfstate", networking = "networking.tfstate" }
  EOT
}

data "terraform_remote_state" "this" {
  for_each = var.remote_state_backend != null ? var.remote_state_keys : {}

  backend = "azurerm"
  config = {
    resource_group_name  = var.remote_state_backend.resource_group_name
    storage_account_name = var.remote_state_backend.storage_account_name
    container_name       = var.remote_state_backend.container_name
    key                  = each.value
    use_azuread_auth     = var.remote_state_backend.use_azuread_auth
  }
}

locals {
  # Feed remote state outputs into the existing remote_states variable
  _remote_states_from_backend = {
    for k, v in data.terraform_remote_state.this : k => v.outputs
  }
}
```

Then the existing `remote_states` context gets populated automatically:

```hcl
# In azure_layers.tf, the existing _ctx_l0 already includes:
#   remote_states = var.remote_states
# Extend to merge both sources:
  remote_states = merge(var.remote_states, local._remote_states_from_backend)
```

YAML configs can then reference upstream state outputs:

```yaml
# configurations/03-compute/config.yaml
azure_storage_accounts:
  logs:
    resource_group_name: ref:remote_states.networking.azure_values.azure_resource_groups.hub.resource_group_name
    location: ref:remote_states.networking.azure_values.azure_resource_groups.hub.location
    account_name: stlogs001
    sku_name: Standard_LRS
    kind: StorageV2
```

---

## Orchestration

### Option A: Makefile / shell script (simple)

```bash
#!/usr/bin/env bash
# scripts/apply.sh — apply multiple configs in dependency order
set -euo pipefail

BACKEND_CONFIG="backends/azurerm.hcl"

declare -A CONFIGS=(
  [identity]="configurations/01-identity/config.yaml"
  [networking]="configurations/02-networking/config.yaml"
  [compute]="configurations/03-compute/config.yaml"
  [k8s-arc]="configurations/04-k8s/config.yaml"
)

# Order matters — upstream first
ORDER=(identity networking compute k8s-arc)

for domain in "${ORDER[@]}"; do
  config="${CONFIGS[$domain]}"
  echo "══════ Applying: $domain ($config) ══════"

  # Each domain gets its own state via -backend-config="key=..."
  terraform init -reconfigure \
    -backend-config="$BACKEND_CONFIG" \
    -backend-config="key=${domain}.tfstate"

  terraform apply -auto-approve \
    -var="config_file=$config" \
    -var='remote_state_keys={"identity":"identity.tfstate"}' \
    # ... add more remote_state_keys per domain
done
```

### Option B: Terragrunt-style wrapper (future)

A dedicated YAML orchestration file declaring dependencies:

```yaml
# orchestration.yaml
states:
  identity:
    config_file: configurations/01-identity/config.yaml
    backend_key: identity.tfstate
    depends_on: []

  networking:
    config_file: configurations/02-networking/config.yaml
    backend_key: networking.tfstate
    depends_on: [identity]

  compute:
    config_file: configurations/03-compute/config.yaml
    backend_key: compute.tfstate
    depends_on: [identity, networking]

  k8s-arc:
    config_file: configurations/04-k8s/config.yaml
    backend_key: k8s-arc.tfstate
    depends_on: [identity, networking]

backend:
  type: azurerm
  resource_group_name: rg-terraform-state
  storage_account_name: stterraformstate001
  container_name: tfstate
  use_azuread_auth: true
```

### Option C: Workspaces per environment (not per domain)

Use Terraform workspaces to isolate dev/staging/prod, but keep domain separation via config files + backend keys:

```bash
terraform workspace select dev
terraform init -backend-config=backends/azurerm.hcl \
               -backend-config="key=dev/networking.tfstate"
terraform apply -var="config_file=configurations/02-networking/config.yaml"
```

---

## Azure Storage Account Bootstrap

The state storage itself needs a one-time bootstrap (cannot be managed by the state it hosts):

```yaml
# configurations/00-bootstrap/config.yaml
# Apply with -backend=false (local state, committed or stored safely)

azure_resource_groups:
  tfstate:
    subscription_id: "YOUR_SUB_ID"
    resource_group_name: rg-terraform-state
    location: westeurope
    tags:
      purpose: terraform-state
      managed_by: bootstrap

azure_storage_accounts:
  tfstate:
    subscription_id: "YOUR_SUB_ID"
    resource_group_name: ref:azure_resource_groups.tfstate.resource_group_name
    account_name: stterraformstate001
    sku_name: Standard_GRS        # GRS for state durability
    kind: StorageV2
    location: ref:azure_resource_groups.tfstate.location
    properties:
      allowBlobPublicAccess: false
      minimumTlsVersion: TLS1_2
      allowSharedKeyAccess: false  # Entra-only auth
    tags: ref:azure_resource_groups.tfstate.tags
```

After bootstrap apply:
1. Create the `tfstate` blob container (via az CLI or add a container resource)
2. Assign `Storage Blob Data Contributor` to the CI/CD identity and operators
3. Migrate existing local state: `terraform init -migrate-state -backend-config=backends/azurerm.hcl -backend-config="key=<domain>.tfstate"`

---

## Directory Structure (proposed)

```
├── .github/
│   └── prompts/
│       └── tfstate-boundary.prompt.md # /tfstate-boundary prompt (reads terraform_backend from YAML)
├── configurations/
│   ├── 00-bootstrap/
│   │   └── config.yaml                # State storage account (local state only)
│   ├── k8s_arc_enrollment.yaml        # (existing — gets terraform_backend section)
│   ├── final_config.yaml              # (existing — gets terraform_backend section)
│   └── ...                            # (existing configs remain valid)
├── backend.tf                         # terraform { backend "azurerm" {} }
├── remote_state_sources.tf            # data.terraform_remote_state + variables
├── azure_layers.tf                    # (modified: merge remote_states sources)
└── *.tf                               # (unchanged)
```

No `backends/` directory needed — the backend config lives in each YAML file's `terraform_backend` section.

---

## Migration Path

| Phase | What | State backend | Cross-state |
|-------|------|---------------|-------------|
| **0 — Today** | Single config, single state | Local | N/A |
| **1 — Split configs** | Multiple YAML configs, each `terraform apply` uses `-backend=false` with separate state dirs | Local (per-config dir) | `var.remote_states` passed manually |
| **2 — Azure backend** | Add `backend.tf` + `backends/azurerm.hcl`, `terraform init -backend-config=...` per domain | Azure Storage | `data.terraform_remote_state` auto-resolved |
| **3 — Orchestration** | Add `scripts/apply.sh` or `orchestration.yaml` to codify dependency order and automate | Azure Storage | Automatic |

### Phase 1 Quick Start (no Azure Storage needed)

```bash
# Apply identity config with isolated local state
mkdir -p .tfstate/identity
terraform init -backend=false
terraform apply \
  -var="config_file=configurations/01-identity/config.yaml" \
  -state=.tfstate/identity/terraform.tfstate

# Apply networking, passing identity outputs
terraform apply \
  -var="config_file=configurations/02-networking/config.yaml" \
  -state=.tfstate/networking/terraform.tfstate \
  -var='remote_states={"identity": ...}'  # or use a .tfvars file
```

---

## Summary of Changes Required

| File | Change | Phase |
|------|--------|-------|
| `azure_layers.tf` | Merge `local._remote_states_from_backend` into `_ctx_l0.remote_states` | 2 |
| `backend.tf` (new) | `terraform { backend "azurerm" {} }` | 2 |
| `remote_state_sources.tf` (new) | `data.terraform_remote_state` + variables | 2 |
| `.github/prompts/tfstate-boundary.prompt.md` (new) | `/tfstate-boundary` prompt that reads `terraform_backend` from YAML | 1 |
| `configurations/00-bootstrap/config.yaml` (new) | State storage account (applied with local state) | 2 |
| Each `configurations/*.yaml` | Add `terraform_backend:` section (metadata) | 1 |
| Existing `*.tf` files | **No changes** (except `azure_layers.tf` in Phase 2) | — |
