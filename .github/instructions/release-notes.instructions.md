---
applyTo: "**/CHANGELOG.md,**/.github/workflows/release.yml,**/RELEASE_NOTES_TEMPLATE.md"
---

# Release Notes Instructions

This repository (`terraform-rest-galaxy`) is the **upstream module** consumed by template-config-repo instances via pinned semver tags. Consumers rely entirely on release notes to understand what changed, what might break, and what action they need to take when bumping versions. Every release **must** include structured, detailed release notes.

## Commit Convention

Use [Conventional Commits](https://www.conventionalcommits.org/) for all commits on `main`:

```
<type>(<scope>): <short description>

[optional body]

[optional footer(s)]
```

### Types

| Type | Meaning | Semver bump |
|------|---------|-------------|
| `feat` | New feature or new module | minor |
| `fix` | Bug fix | patch |
| `refactor` | Code change that neither fixes a bug nor adds a feature | patch |
| `docs` | Documentation only | none |
| `test` | Adding or correcting tests | none |
| `ci` | CI/CD workflow changes | none |
| `chore` | Maintenance (deps, formatting) | none |
| `perf` | Performance improvement | patch |
| `BREAKING CHANGE` | Footer or `!` after type — triggers major bump | major |

### Scope

Scope **must** be one of:
- A module name from `modules/azure/` (e.g., `storage_account`, `managed_cluster`, `virtual_network`)
- A module name from `modules/entraid/`, `modules/github/`, `modules/k8s/`
- `config` — for config.yaml schema changes
- `provider` — for provider block or version constraint changes
- `backend` — for backend interface changes
- `workflow` — for reusable workflow changes
- `deps` — for dependency updates
- `core` — for root module / tf.sh / shared logic

### Examples

```
feat(storage_account): add customer-managed key support

fix(managed_cluster): correct polling interval for node pool updates

feat(config): add azure_redis_enterprise_clusters config section

refactor(virtual_network)!: rename subnet_ids output to subnet_id_map

BREAKING CHANGE: output `subnet_ids` is now `subnet_id_map` (map keyed by subnet name)

ci(workflow): add plan-only test stage to release pipeline

chore(deps): bump restful provider to v0.16.0
```

## CHANGELOG.md Format

Maintain `CHANGELOG.md` at the repo root using [Keep a Changelog](https://keepachangelog.com/) format. Group entries under the following headings:

```markdown
# Changelog

## [Unreleased]

## [1.2.0] - 2026-04-08

### Breaking Changes
- **storage_account**: Renamed `account_tier` + `account_replication_type` to unified `sku_name` field.
  - **Migration**: Replace `account_tier: Standard` / `account_replication_type: GRS` with `sku_name: Standard_GRS`.
  - **Config impact**: All `azure_storage_accounts` entries must be updated.

### Added
- **redis_enterprise_cluster**: New module for Azure Cache for Redis Enterprise.
- **redis_enterprise_database**: New module for Redis Enterprise databases.
- **config**: New `azure_redis_enterprise_clusters` config section.

### Changed
- **managed_cluster**: Updated API version from 2024-09-01 to 2025-03-01.
- **virtual_network**: Improved subnet delegation handling.

### Fixed
- **key_vault**: Fixed 404 polling during soft-delete recovery.
- **private_endpoint**: Corrected DNS zone group lifecycle ordering.

### Deprecated
- **storage_account**: `account_tier` and `account_replication_type` fields (use `sku_name` instead). Will be removed in v3.0.0.

### Removed
- **billing_permission_request**: Removed obsolete module (API retired by Azure).

### Dependencies
- Bumped `magodo/restful` provider to v0.16.0.
- Bumped Terraform minimum version to 1.14.5.

### Internal
- Added plan-only tests for VWAN Secure Hub scenario.
- Improved CI release pipeline with structured release notes.
```

### Rules

1. **Every PR to `main` must update the `[Unreleased]` section** in CHANGELOG.md.
2. At release time, the workflow renames `[Unreleased]` to `[X.Y.Z] - YYYY-MM-DD` and creates a fresh `[Unreleased]`.
3. **Breaking Changes** must always include:
   - What changed (old → new)
   - **Migration** steps (exact config diff or commands)
   - **Config impact** (which config sections are affected)
4. **Added** entries for new modules must mention the config section name consumers will use.
5. **Changed** entries for API version bumps must note old and new versions.
6. **Deprecated** entries must state the replacement and the target removal version.

## GitHub Release Body Structure

The release workflow generates a GitHub Release with this structure:

```markdown
## v1.2.0

### Upgrade Priority
<!-- One of: 🔴 Critical (security/data-loss fix), 🟡 Recommended, 🟢 Optional -->
🟡 Recommended

### Breaking Changes
<!-- If none, write "None" -->
- **storage_account**: `account_tier`/`account_replication_type` replaced by `sku_name`.
  - **Action required**: Update all `azure_storage_accounts` entries.
  - See [migration guide](#migration-storage-account-sku).

### New Modules
- `redis_enterprise_cluster` — Azure Cache for Redis Enterprise
- `redis_enterprise_database` — Redis Enterprise databases

### New Config Sections
- `azure_redis_enterprise_clusters`
- `azure_redis_enterprise_databases`

### Module Changes
| Module | Change | API Version |
|--------|--------|-------------|
| managed_cluster | Updated API version | 2024-09-01 → 2025-03-01 |
| virtual_network | Improved subnet delegation | — |

### Bug Fixes
- **key_vault**: Fixed 404 polling during soft-delete recovery.
- **private_endpoint**: Corrected DNS zone group lifecycle ordering.

### Deprecations
| Item | Replacement | Removed in |
|------|-------------|------------|
| `storage_account.account_tier` | `sku_name` | v3.0.0 |

### Dependencies
- `magodo/restful` provider: v0.15.0 → v0.16.0
- Terraform minimum: 1.14.0 → 1.14.5

### Migration Guides

#### Migration: storage_account SKU {#migration-storage-account-sku}

**Before** (v1.x):
```yaml
azure_storage_accounts:
  data:
    account_tier: Standard
    account_replication_type: GRS
```

**After** (v1.2.0+):
```yaml
azure_storage_accounts:
  data:
    sku_name: Standard_GRS
```

### Full Changelog
<!-- Auto-generated commit list -->
```

## Determining Semver Bump

When preparing a release:

1. Scan all commits since the last tag.
2. If **any** commit has `BREAKING CHANGE` footer or `!` after the type → **major** bump.
3. Else if **any** commit has type `feat` → **minor** bump.
4. Else → **patch** bump.

## Pre-release Tags

For release candidates: `v1.2.0-rc1`, `v1.2.0-rc2`, etc.
- Pre-release notes should include a **known issues** section.
- Mark the GitHub release as pre-release.

## Checklist Before Tagging

- [ ] `CHANGELOG.md` `[Unreleased]` section has all entries from merged PRs
- [ ] Breaking changes include migration guides with before/after config examples
- [ ] New modules list the corresponding config section name
- [ ] API version bumps list old → new version
- [ ] Deprecated items list the replacement and removal target version
- [ ] All tests pass (`terraform test`)
- [ ] `terraform fmt -check -recursive .` passes
- [ ] Version bump follows semver rules based on commit types
