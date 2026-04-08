# Release Notes Template

Copy the relevant sections into `CHANGELOG.md` under `## [Unreleased]` when merging a PR.

---

## Sections Reference

### Breaking Changes

Use when a change requires consumers to update their `config.yaml` or workflow files.

```markdown
### Breaking Changes
- **<module_name>**: <what changed>.
  - **Migration**: <exact steps — before/after config YAML>.
  - **Config impact**: `<config_section_name>` entries must be updated.
```

### Added

Use for new modules, new config sections, or new features in existing modules.

```markdown
### Added
- **<module_name>**: <description of new module or feature>.
- **config**: New `<config_section_name>` config section for <purpose>.
```

### Changed

Use for non-breaking modifications to existing modules (API version bumps, behavior changes).

```markdown
### Changed
- **<module_name>**: <what changed>. API version: `<old>` → `<new>`.
```

### Fixed

Use for bug fixes.

```markdown
### Fixed
- **<module_name>**: <what was broken and how it was fixed>.
```

### Deprecated

Use when a field, module, or behavior is being phased out.

```markdown
### Deprecated
- **<module_name>**: `<field_name>` is deprecated — use `<replacement>` instead. Will be removed in v<X>.0.0.
```

### Removed

Use when a module or feature is deleted.

```markdown
### Removed
- **<module_name>**: Removed (<reason>).
```

### Dependencies

Use for provider or Terraform version changes.

```markdown
### Dependencies
- Bumped `<provider>` to v<X.Y.Z>.
- Bumped Terraform minimum version to <X.Y.Z>.
```

---

## Full Example Entry

```markdown
## [Unreleased]

### Breaking Changes
- **storage_account**: Renamed `account_tier` + `account_replication_type` to unified `sku_name`.
  - **Migration**: Replace `account_tier: Standard` / `account_replication_type: GRS` with `sku_name: Standard_GRS`.
  - **Config impact**: All `azure_storage_accounts` entries must be updated.

### Added
- **redis_enterprise_cluster**: New module for Azure Cache for Redis Enterprise.
- **config**: New `azure_redis_enterprise_clusters` config section.

### Changed
- **managed_cluster**: Updated API version from 2024-09-01 to 2025-03-01.

### Fixed
- **key_vault**: Fixed 404 polling during soft-delete recovery.

### Deprecated
- **storage_account**: `account_tier` field — use `sku_name` instead. Removed in v3.0.0.

### Dependencies
- Bumped `magodo/restful` provider to v0.16.0.
```
