---
applyTo: "**/*.tftest.hcl"
---

# Terraform Test Conventions

## Galaxy Build Step

Source `.tf` files live in `galaxy/` organized by provider and domain. Terraform requires all `.tf` files in one flat directory, so before running any `terraform` command you must build the flat layout:

```bash
scripts/build-galaxy.sh          # generates .build/ with flat files
terraform -chdir=.build test     # run tests from .build/
```

Or use `tf.sh` which runs the build automatically:
```bash
./tf.sh plan configurations/<config>.yaml
```

**Two development workflows:**

| Workflow | Edit in | Build | Test | Sync back |
|----------|---------|-------|------|-----------|
| **Galaxy-first** (recommended) | `galaxy/<provider>/<domain>/<file>.tf` | `scripts/build-galaxy.sh` | `terraform -chdir=.build test` | N/A (source is galaxy/) |
| **Build-first** (quick iteration) | `.build/<flat_file>.tf` | N/A (already flat) | `terraform -chdir=.build test` | `scripts/build-galaxy.sh --reverse` |

The reverse sync maps flat filenames back to galaxy paths using the `__` separator convention:
- `azure__networking__route_tables.tf` → `galaxy/azure/networking/route_tables.tf`
- `entraid__applications.tf` → `galaxy/entraid/applications.tf`
- `main.tf` (no `__`) → `galaxy/shared/main.tf`

## Directory Layout

Real test files live in categorised subdirectories; **symlinks** in the top-level `tests/` directory point to them so that `terraform test` (which only scans the immediate `tests/` folder) discovers every file.

```
tests/
  unit_tests/
    azure/          # unit_azure_*.tftest.hcl  (real files)
    entraid/        # unit_entraid_*.tftest.hcl (real files)
  integration_plans/
    azure/          # integration_azure_*.tftest.hcl + integration_config_*.tftest.hcl (real files)
    entraid/        # integration_entraid_*.tftest.hcl (real files)
  end_to_end/       # (future: apply+destroy tests)
  unit_azure_*.tftest.hcl          -> symlinks to unit_tests/azure/*
  unit_entraid_*.tftest.hcl        -> symlinks to unit_tests/entraid/*
  integration_azure_*.tftest.hcl   -> symlinks to integration_plans/azure/*
  integration_config_*.tftest.hcl  -> symlinks to integration_plans/azure/*
  integration_entraid_*.tftest.hcl -> symlinks to integration_plans/entraid/*
```

**When adding a new test file**, always:
1. Create the real file in the appropriate subdirectory.
2. Create a relative symlink in `tests/`: `ln -s <subdir>/<filename> tests/<filename>`

Run all tests: `terraform -chdir=.build test` (after running `scripts/build-galaxy.sh`).
Run one test: `terraform -chdir=.build test -filter=tests/<filename>.tftest.hcl`

## Test Categories

Tests are split into **unit** and **integration** tests, distinguished by filename prefix.

### Unit Tests (`unit_azure_*` / `unit_entraid_*`)

**Purpose:** Test a single sub-module in isolation using `command = plan` only. No real Azure/Graph credentials needed.

**Naming:** `tests/unit_tests/azure/unit_azure_<module_name>.tftest.hcl` or `tests/unit_tests/entraid/unit_entraid_<module_name>.tftest.hcl` (with symlink in `tests/`)

**Coverage rule:** Every module in `modules/azure/` and `modules/entraid/` **MUST** have a corresponding unit test. When creating a new module, always create the unit test at the same time.

**Structure:**
- Declares its **own provider block** (needed because `module { source }` creates a separate provider context)
- Uses a `run` block with `command = plan` and `module { source = "./modules/azure/<name>" }` (or `./modules/entraid/<name>`) — these relative paths resolve from `.build/` via its `modules` symlink
- Passes fake/placeholder values for all required variables
- Asserts only **plan-time-known** outputs (values derived from input variables, not from `rest_resource.*.output`)
- Token is always `"placeholder"` — the plan never calls Azure

**Azure sub-module template:**
```hcl
# Unit test — modules/azure/<module_name>
# Run: terraform test -filter=tests/unit_azure_<module_name>.tftest.hcl

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

run "plan_<module_name>" {
  command = plan

  module {
    source = "./modules/azure/<module_name>"
  }

  variables {
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    resource_group_name = "test-rg"
    # ... all required variables with test values
  }

  assert {
    condition     = output.id == "<expected ARM path>"
    error_message = "ARM ID must be correctly formed."
  }

  assert {
    condition     = output.name == "<expected_name>"
    error_message = "Name output must echo input."
  }
}
```

**Entra ID sub-module template:**
```hcl
# Unit test — modules/entraid/<module_name>
# Run: terraform test -filter=tests/unit_entraid_<module_name>.tftest.hcl

provider "rest" {
  base_url = "https://graph.microsoft.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

run "plan_<module_name>" {
  command = plan

  module {
    source = "./modules/entraid/<module_name>"
  }

  variables {
    # ... all required variables with test values
  }

  assert {
    condition     = output.<plan_time_attr> == "<expected>"
    error_message = "..."
  }
}
```

**Key rules for unit tests:**
- Only assert outputs that are known at plan time (computed from input variables, not API responses)
- Outputs that come from `rest_resource.*.output.*` or use `try(..., null)` are NOT plan-time-known — skip them
- Do NOT declare variables the module doesn't have (causes "undeclared variable" warnings)
- The provider block is REQUIRED in unit tests (unlike integration tests)
- Use `"placeholder"` as the token value — never a real token

### Integration Tests (`integration_azure_*` / `integration_config_*` / `integration_entraid_*`)

**Purpose:** Test the **root module** end-to-end. May use `command = plan` (with placeholders) or `command = apply` (with real credentials).

**Naming:**
- `tests/integration_azure_<resource_name>.tftest.hcl` — single Azure resource type via root module
- `tests/integration_config_<scenario_name>.tftest.hcl` — composite YAML configuration via root module
- `tests/integration_entraid_<resource_name>.tftest.hcl` — Entra ID resource type via root module

**Structure:**
- Does **NOT** declare a provider block — the root module's provider config in `azure_provider.tf` is used
- Does **NOT** use `module { source = ... }` — tests drive the root module directly
- Uses root module map variables (`azure_resource_groups`, `azure_storage_accounts`, etc.)
- References outputs via `output.azure_values.<plural>["key"].<attr>` or `output.entraid_values.<plural>["key"].<attr>`
- Plan-only tests use `default = "placeholder"` for token variables
- Apply tests declare token variables without defaults (require `TF_VAR_access_token` / `TF_VAR_graph_access_token`)

**Integration plan-only template:**
```hcl
# Integration test — <resource_name> (plan only)
# Run: terraform test -filter=tests/integration_azure_<resource_name>.tftest.hcl

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

run "plan_<resource_name>" {
  command = plan

  variables {
    azure_<plural_resource_name> = {
      test = {
        subscription_id     = "00000000-0000-0000-0000-000000000000"
        resource_group_name = "test-rg"
        # ... required vars
      }
    }
  }

  assert {
    condition     = output.azure_values.azure_<plural>["test"].id != null
    error_message = "..."
  }
}
```

**Integration config (YAML scenario) template:**
```hcl
# Integration test — configurations/<scenario_name>.yaml (plan only)
# Run: terraform test -filter=tests/integration_config_<scenario_name>.tftest.hcl

variable "access_token" {
  type      = string
  sensitive = true
  default   = "placeholder"
}

run "plan_<scenario_name>" {
  command = plan

  variables {
    config_file     = "configurations/<scenario_name>.yaml"
    subscription_id = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = output.azure_values.azure_resource_groups["<key>"] != null
    error_message = "Plan failed — resource group not found."
  }
}
```

**Key rules for integration tests:**
- NEVER add a `provider "rest"` block — it causes "Provider type mismatch" errors when unit tests with `module { source }` coexist in the same `tests/` directory
- The root module's provider configuration flows through automatically
- Plan-only integration tests use `default = "placeholder"` for auth tokens
- Apply integration tests leave auth token defaults as `null` (require env vars)

## Critical Compatibility Rule

Because `terraform test` loads ALL `*.tftest.hcl` files in `tests/` together:
- Unit tests MUST have their own `provider "rest"` block (needed by `module { source }`)
- Integration tests MUST NOT have a `provider "rest"` block (root module provides it)
- If an integration test adds a `provider "rest"` block, it defaults to `LaurentLesle/rest` and conflicts with the root module's `LaurentLesle/rest` — breaking ALL tests

## When Creating a New Module

Every new module requires **both**:
1. A **unit test**: `tests/unit_tests/azure/unit_azure_<name>.tftest.hcl` (or `tests/unit_tests/entraid/unit_entraid_<name>.tftest.hcl`) plus a symlink: `ln -s unit_tests/azure/unit_azure_<name>.tftest.hcl tests/unit_azure_<name>.tftest.hcl`
2. An **integration test**: `tests/integration_plans/azure/integration_azure_<name>.tftest.hcl` (or `tests/integration_plans/entraid/...`) plus a symlink: `ln -s integration_plans/azure/integration_azure_<name>.tftest.hcl tests/integration_azure_<name>.tftest.hcl`

For composite scenarios with a YAML config, also create:
3. A **config integration test**: `tests/integration_plans/azure/integration_config_<scenario_name>.tftest.hcl` plus symlink

## Running Tests

All `terraform` commands run from `.build/`. Always build first:

```bash
# Build the flat layout
scripts/build-galaxy.sh

# All tests (unit + integration)
terraform -chdir=.build test

# Only unit tests
terraform -chdir=.build test -filter='tests/unit_*.tftest.hcl'

# Only integration tests
terraform -chdir=.build test -filter='tests/integration_*.tftest.hcl'

# Single test
terraform -chdir=.build test -filter=tests/unit_azure_resource_group.tftest.hcl

# Apply tests need real credentials
export TF_VAR_access_token=$(az account get-access-token --resource https://management.azure.com --query accessToken -o tsv)
export TF_VAR_graph_access_token=$(az account get-access-token --resource https://graph.microsoft.com --query accessToken -o tsv)
export TF_VAR_subscription_id=$(az account show --query id -o tsv)
terraform -chdir=.build test
```

Or use `tf.sh` which builds automatically:
```bash
./tf.sh test
./tf.sh test -filter=tests/unit_azure_resource_group.tftest.hcl
```

**Note:** `terraform test -filter` does NOT support globs. Each `-filter` flag matches one file. To run multiple specific tests, use multiple `-filter` flags.
