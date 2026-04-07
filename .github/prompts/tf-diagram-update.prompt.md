---
description: "Refresh an existing Draw.io diagram after config.yaml changes"
---

# Update Architecture Diagram

Compare the current `config.yaml` with the existing `.drawio` diagram and apply incremental changes.

## Arguments
- `$input` — description of what changed (e.g. "added a new VNet" or "updated hub connections"), or leave empty for full diff

## Steps

1. Read `config.yaml` and extract all resource types, resources, and `ref:` dependencies
2. Use `list-paged-model` to inventory all existing cells in the open `.drawio` file
3. Diff: identify resources in config that are missing from the diagram (additions) and cells in the diagram that no longer exist in config (removals)
4. For **additions**: follow the tf-diagram skill procedure (Step 2-5) to add new shapes and edges
5. For **removals**: use `delete-cell-by-id` to remove stale cells and their edges
6. For **changes**: use `edit-cell` to update labels or `edit-edge` to update connections
7. Verify with `list-paged-model` that the diagram matches the config
