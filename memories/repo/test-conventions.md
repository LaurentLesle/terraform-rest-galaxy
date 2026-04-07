# Test Conventions

- All tests live **flat** in `tests/` — no subdirectories (terraform test only discovers top-level)
- Unit tests: `unit_azure_*` / `unit_entraid_*` — sub-module isolation, plan only, own provider block
- Integration tests: `integration_azure_*` / `integration_config_*` / `integration_entraid_*` — root module, NO provider block
- Integration tests MUST NOT have `provider "rest"` blocks (causes type mismatch with unit tests)
- Every new module needs BOTH a unit test and an integration test
- Run all: `terraform test` from repo root
- Full conventions: `.github/instructions/testing.instructions.md`
- Old `tests/azure/` and `tests/entraid/` subdirectory paths are OBSOLETE — everything is flat in `tests/`
