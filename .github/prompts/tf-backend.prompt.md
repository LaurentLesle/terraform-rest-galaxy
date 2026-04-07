---
description: "Add a terraform_backend block to a YAML configuration file. Analyses the file content to derive a meaningful, unique state key. Use when: add backend, terraform_backend, add state, configure backend, add tfstate, wire up state"
argument-hint: "Path to the YAML config file (e.g. configurations/acme_vwan_expressroute.yaml)"
mode: "agent"
tools: ["read", "edit"]
---

# Add terraform_backend to a YAML config

Add a `terraform_backend` section to the provided YAML configuration file so its state is managed in Azure Storage.

## Input

- `$input` — path to the target YAML config file.

## Procedure

1. **Read the file.** If it already contains a `terraform_backend:` block, inform the user and stop — do not overwrite.

2. **Derive the state key** from the file path and content:
   - For flat files (`configurations/<name>.yaml`): use `<name>.tfstate` where `<name>` is the filename without extension, preserving snake_case (Terraform community convention).
     Example: `acme_vwan_expressroute.yaml` → key `acme_vwan_expressroute.tfstate`
   - For subdirectory configs (`configurations/<dir>/config.yaml`): use `<dir>.tfstate` (strip any numeric prefix like `01-`).
     Example: `configurations/01-launchpad/config.yaml` → key `launchpad.tfstate`
   - The key must be unique across all existing configs. Scan `configurations/` for other `terraform_backend.key` values to confirm no collision.

3. **Detect remote_states dependencies.** Look for `ref:remote_states.*` patterns in the file content. For each unique remote state name found, add it to `remote_states` with its corresponding key. If none are found, omit `remote_states`.

4. **Insert the block** immediately after the file's header comment block (before the first resource section). Use this template:

```yaml
# ── State backend ────────────────────────────────────────────────────────────
terraform_backend:
  type: azurerm
  resource_group_name: rg-terraform-state
  storage_account_name: stdplstate001
  container_name: tfstate
  key: <derived-key>
```

If remote states were detected, append:

```yaml
  remote_states:
    <name>:
      key: <name>.tfstate
```

5. **Show the user** what was added and confirm the key is unique.

## Naming rules

| Pattern | Key |
|---------|-----|
| `configurations/foo_bar.yaml` | `foo_bar.tfstate` |
| `configurations/02-networking/config.yaml` | `networking.tfstate` |
| `configurations/acme_vwan_expressroute.yaml` | `acme_vwan_expressroute.tfstate` |

## Backend defaults

These values come from the 00-bootstrap deployment and should be consistent across all configs:

| Field | Value |
|-------|-------|
| `type` | `azurerm` |
| `resource_group_name` | `rg-terraform-state` |
| `storage_account_name` | `stdplstate001` |
| `container_name` | `tfstate` |
