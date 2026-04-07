---
name: tf-test
description: "Use when: testing a Terraform example with terraform init and terraform plan. Triggers: tf_test, test module, plan example, terraform init plan, validate example, check example, tf test resource_group, tf_test complete, tf_test minimum"
argument-hint: "<module-name> [complete|minimum]  — e.g. 'resource_group complete'"
---

# tf-test

Run `terraform init` + `terraform plan` against an example configuration, automatically using local Azure CLI credentials when available.

## When to Use

Whenever you see a request like:
- `tf_test resource_group`
- `tf_test resource_group complete`
- `tf_test resource_group minimum`
- "test the resource_group module", "plan the complete example"

## Inputs

| Argument | Required | Default | Description |
|----------|----------|---------|-------------|
| `module-name` | yes | — | Folder name under `examples/azure/` (e.g. `resource_group`) |
| `variant` | no | `minimum` | `minimum` or `complete` |

## Procedure

1. Resolve the target directory:
   ```
   examples/azure/<module-name>/<variant>/
   ```
   If the variant is omitted, default to `minimum`.

2. Verify the directory exists. If it does not, list `examples/azure/` and tell the user which modules and variants are available.

3. Read `examples/azure/<module-name>/<variant>/variables.tf` to discover all required variables (those without `default`). Build the list of `-var` flags needed for module-specific inputs (skip auth vars — they are handled automatically below).

4. Detect the auth mode — run this in the terminal to check Azure CLI login status:

   ```bash
   az account show --query id -o tsv 2>/dev/null
   ```

   Then run the full sequence **as a VS Code task** (using `create_and_run_task`) so it executes in the VS Code terminal panel and the user can follow the output there. Use task label `tf-test: <module-name> <variant>`.

   **a) Local dev** — Azure CLI is logged in (probe returned a subscription ID):
   ```json
   {
     "label": "tf-test: <module-name> <variant>",
     "type": "shell",
     "group": "test",
     "isBackground": false,
     "problemMatcher": [],
     "command": "export TF_VAR_access_token=$(az account get-access-token --resource https://management.azure.com --query accessToken -o tsv) && export TF_VAR_subscription_id=$(az account show --query id -o tsv) && echo \"Token acquired for subscription $TF_VAR_subscription_id\" && terraform -chdir=examples/azure/<module-name>/<variant> init -backend=false && terraform -chdir=examples/azure/<module-name>/<variant> plan -var='resource_group_name=test-rg' -var='location=westeurope' <other-required-vars>"
   }
   ```

   **b) Dry-run** — Azure CLI not available or not logged in:
   ```json
   {
     "label": "tf-test: <module-name> <variant>",
     "type": "shell",
     "group": "test",
     "isBackground": false,
     "problemMatcher": [],
     "command": "terraform -chdir=examples/azure/<module-name>/<variant> init -backend=false && terraform -chdir=examples/azure/<module-name>/<variant> plan -var='subscription_id=00000000-0000-0000-0000-000000000000' -var='resource_group_name=test-rg' -var='location=westeurope' <other-required-vars>"
   }
   ```
   Auth vars (`id_token`, `tenant_id`, `client_id`, `access_token`) all default to `null` — safe to omit.

5. After the task completes, summarise the result: auth mode used, subscription ID (if local dev), and the final `Plan: N to add` line.

## Notes

- **Local dev**: `rest_operation.access_token` shows `0 to add` (skipped via `count = 0` because `TF_VAR_access_token` is set).
- **Dry-run**: `rest_operation.access_token` shows `1 to add` — expected, the OIDC exchange only runs at apply time.
- To also format before testing: `terraform fmt -recursive examples/azure/<module-name>/`
- The helper script `.github/scripts/get-dev-token.sh` does the same token fetch if the user wants to set the env var manually in their shell.

## Terraform Test Suite

This skill also covers running the native `terraform test` suite. All test files live **flat** in `tests/` — see `.github/instructions/testing.instructions.md` for full conventions.

### Quick reference

```bash
# All tests (unit + integration)
terraform test

# Only unit tests (sub-module isolation, plan only)
terraform test -filter='tests/unit_*.tftest.hcl'

# Only integration tests (root module)
terraform test -filter='tests/integration_*.tftest.hcl'

# Single test
terraform test -filter=tests/unit_azure_resource_group.tftest.hcl
```

### Test types

| Prefix | Purpose | Provider block? | Uses `module { source }` ? |
|--------|---------|-----------------|---------------------------|
| `unit_azure_*` | Azure sub-module isolation (plan only) | YES (own block) | YES |
| `unit_entraid_*` | Entra ID sub-module isolation (plan only) | YES (Graph base_url) | YES |
| `integration_azure_*` | Root module single-resource test | NO | NO |
| `integration_config_*` | Root module YAML configuration test | NO | NO |
| `integration_entraid_*` | Root module Entra ID test | NO | NO |

**Critical:** Integration tests must NOT have `provider "rest"` blocks — they conflict with unit tests. See the instruction file for details.
