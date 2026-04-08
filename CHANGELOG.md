# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/),
and this project adheres to [Semantic Versioning](https://semver.org/).

## [Unreleased]

## [1.1.0] - 2026-04-09

### Added
- **ci**: Structured release notes extracted from CHANGELOG.md with upgrade priority classification (🔴/🟡/🟢) and commit stats.
- **docs**: CHANGELOG.md following [Keep a Changelog](https://keepachangelog.com/) format.
- **docs**: Release notes template (`.github/RELEASE_NOTES_TEMPLATE.md`) for PR authors.
- **docs**: Release notes instructions (`.github/instructions/release-notes.instructions.md`) defining conventional commit conventions, changelog format, and GitHub Release body structure.

### Changed
- **workflow**: Release workflow now reads from CHANGELOG.md instead of raw git log, with automatic fallback for missing entries.

## [1.0.1] - 2026-04-08

### Fixed
- **core**: Removed `backend.tf` and empty provider block for child-module compatibility.
  Consumers embedding this as a child module no longer get backend/provider conflicts.

## [1.0.0] - 2026-04-08

### Added
- Initial release of Terraform REST provider modules for Agentic IaC.
- **azure**: 56 modules covering resource groups, storage accounts, networking (VNet, VPN, ExpressRoute, VWAN), DNS, Key Vault, AKS, container registries, Redis Enterprise, PostgreSQL, firewalls, private endpoints, load balancers, and more.
- **entraid**: Entra ID (Azure AD) modules.
- **github**: GitHub provider modules.
- **k8s**: Kubernetes provider modules.
- **config**: YAML-driven configuration schema with `ref:` cross-references.
- **workflow**: Reusable GitHub Actions workflows for plan/apply/destroy.
- **core**: `tf.sh` orchestrator script for local and CI usage.

### Dependencies
- `magodo/restful` provider.
- Terraform >= 1.14.5.

[Unreleased]: https://github.com/LaurentLesle/galaxy/compare/v1.1.0...HEAD
[1.1.0]: https://github.com/LaurentLesle/galaxy/compare/v1.0.1...v1.1.0
[1.0.1]: https://github.com/LaurentLesle/galaxy/compare/v1.0.0...v1.0.1
[1.0.0]: https://github.com/LaurentLesle/galaxy/releases/tag/v1.0.0
