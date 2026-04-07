# Version Upgrade Guide

This guide helps configuration repository teams safely upgrade to new module versions.

## Understanding Versions

Module versions follow **Semantic Versioning** (semver):

```
v1.2.3-rc1
│ │ │ │
│ │ │ └─ Pre-release (rc1, alpha, beta)
│ │ └─── Patch version (bug fixes, no breaking changes)
│ └───── Minor version (new features, backward-compatible)
└─────── Major version (breaking changes)
```

| Change | Example | Compatibility | Action Required |
|--------|---------|---|---|
| **Patch** | v1.0.0 → v1.0.1 | ✅ Safe | Update anytime |
| **Minor** | v1.0.0 → v1.1.0 | ✅ Safe | Update, test in dev |
| **Major** | v1.0.0 → v2.0.0 | ⚠️ Breaking | Read release notes, update configs |
| **Pre-release** | v1.0.0 → v1.1.0-rc1 | ⚠️ Experimental | Test in non-prod only |

---

## Pre-Upgrade Checklist

Before upgrading any module version:

- [ ] Read release notes at [Releases](../../../releases)
- [ ] Check for breaking changes (marked **BREAKING CHANGE** in notes)
- [ ] Review terraform plan output in staging environment
- [ ] Verify no manual Azure resources need state import
- [ ] Have rollback plan ready

---

## Patch Version Upgrade (v1.0.0 → v1.0.1)

**Risk Level**: 🟢 Low

Patch versions contain only bug fixes. Safe to update immediately.

### Steps

1. **Update module version in workflow**:
   ```yaml
   env:
     MODULE_REPO_TAG: v1.0.1  # from v1.0.0
   ```

2. **Trigger plan** (optional, but recommended):
   ```bash
   git checkout -b upgrade/v1.0.1
   git push origin upgrade/v1.0.1
   # Create PR
   # Verify plan shows no changes
   ```

3. **Merge & Deploy**:
   ```bash
   # Merge PR to main
   # Workflow automatically applies with new version
   ```

---

## Minor Version Upgrade (v1.0.0 → v1.1.0)

**Risk Level**: 🟡 Low-Medium

Minor versions add features but remain backward-compatible. Test in dev environment first.

### Steps

1. **Check what's new**:
   ```bash
   # Review release notes
   # Look for new resources or features
   ```

2. **Test in dev environment**:
   ```yaml
   # .github/workflows/deploy.yml
   env:
     MODULE_REPO_TAG: v1.1.0  # temporarily
   
   # For dev only:
   plan-dev:
     uses: <owner>/<module-repo>/.github/workflows/deploy.yml@${{ env.MODULE_REPO_TAG }}
     with:
       config_file: configurations/env-dev/config.yaml
   ```

3. **Create test branch**:
   ```bash
   git checkout -b upgrade/v1.1.0-test
   # Edit workflow or config to test new features
   git push origin upgrade/v1.1.0-test
   # Create PR, review plan
   ```

4. **Verify plan is acceptable**:
   - No unexpected resource deletions
   - Changes are what you expect
   - No conflict with manual changes

5. **Merge test branch**:
   ```bash
   # Merge test branch to main
   # dev environment deploys with v1.1.0
   ```

6. **Test in staging** (if applicable):
   ```yaml
   # After dev is stable, update staging
   env:
     MODULE_REPO_TAG: v1.1.0
   ```

7. **Rolling deploy to prod**:
   ```yaml
   # Only after staging successful
   env:
     MODULE_REPO_TAG: v1.1.0
   ```

Example workflow:
```
Dev (v1.0.0) → Test v1.1.0 → Merge → Dev (v1.1.0)
                           ↓
                    Staging (v1.0.0) → Update → Staging (v1.1.0)
                                            ↓
                           Prod (v1.0.0) → Update → Prod (v1.1.0)
```

---

## Major Version Upgrade (v1.0.0 → v2.0.0)

**Risk Level**: 🔴 High

Major versions contain breaking changes. Thorough testing and potential config updates required.

### Pre-Upgrade

1. **Read BREAKING CHANGES section** in release notes carefully
2. **Identify affected resources** in your configs
3. **Plan config changes** needed
4. **Test locally first**:
   ```bash
   git clone <module-repo>
   cd <module-repo>
   git checkout v2.0.0
   
   TOKEN=$(az account get-access-token --resource https://management.azure.com --query accessToken -o tsv)
   TF_CI_MODE=true TF_VAR_azure_access_token="$TOKEN" \
     TF_VAR_subscription_id=$(az account show --query id -o tsv) \
     ./tf.sh plan /path/to/config.yaml
   # Review plan for issues
   ```

### Migration Path

1. **Create feature branch**:
   ```bash
   git checkout -b upgrade/v2.0.0-breaking
   ```

2. **Update configs** per release notes:
   Example breaking change:
   ```yaml
   # OLD (v1.0.0)
   azure_storage_accounts:
     data:
       account_tier: Standard
       account_replication_type: GRS

   # NEW (v2.0.0) — unified into sku_name
   azure_storage_accounts:
     data:
       sku_name: Standard_GRS
   ```

3. **Update workflow** to new version:
   ```yaml
   env:
     MODULE_REPO_TAG: v2.0.0  # from v1.0.0
   ```

4. **Test in dev** (non-production):
   ```bash
   git push origin upgrade/v2.0.0-breaking
   # Create PR
   # **Wait for plan to complete**
   # Review plan carefully—verify it matches expected changes
   ```

5. **Review plan output**:
   - Look for `resource_group_id` → verify correct storage account
   - Look for `taint` or `create_before_destroy` sequences
   - Check for any unexpected deletions

6. **If plan looks wrong**:
   - Don't merge
   - Create issue with plan output
   - Wait for module repo to clarify

7. **Merge to dev**:
   ```bash
   # After plan is acceptable
   # Merge PR to main
   # Dev environment deploys with v2.0.0
   # Monitor for errors
   ```

8. **Staging deployment** (if applicable):
   ```bash
   git checkout -b upgrade/v2.0.0-staging
   # Same config changes as dev
   git push origin upgrade/v2.0.0-staging
   # Create PR, review plan
   # Merge when plan acceptable
   ```

9. **Production deployment** (final):
   ```bash
   git checkout -b upgrade/v2.0.0-prod
   # Same config changes
   git push origin upgrade/v2.0.0-prod
   # Create PR
   # Get multiple approvals from senior team members
   # Review plan carefully
   # Merge only if confident
   ```

### Rollback Plan

If v2.0.0 causes issues:

1. **Revert config changes**:
   ```bash
   git revert <commit-hash>
   git push origin feature/revert-v2.0.0
   # Create PR to main
   ```

2. **Revert module version**:
   ```yaml
   env:
     MODULE_REPO_TAG: v1.0.0  # back to previous
   ```

3. **Apply revert**:
   ```bash
   # Merge revert PR
   # Workflow applies with v1.0.0
   # State should match v1.0.0 snapshot
   ```

---

## Pre-Release Version Upgrade (v1.0.0 → v1.1.0-rc1)

**Risk Level**: 🔴 High (Experimental)

Pre-release versions are for testing only. Use in non-production environments only.

### Usage

1. **Dev environment only**:
   ```yaml
   env:
     MODULE_REPO_TAG: v1.1.0-rc1
     # This should ONLY run for dev, never prod
   ```

2. **Test thoroughly**:
   - Run full test suite
   - Monitor for errors
   - Provide feedback to module repo (GitHub Issues)

3. **Wait for stable release**:
   ```yaml
   # Once v1.1.0 (stable) is released
   env:
     MODULE_REPO_TAG: v1.1.0  # upgrade from v1.1.0-rc1
   ```

### Limitations

- No production support on pre-releases
- No SLA/guarantees
- Breaking changes possible before stable release
- Do not use in staging/prod

---

## Common Upgrade Scenarios

### Scenario: New Resource Type Available

**Release Notes**: "Added support for azure_data_factory"

```yaml
# Step 1: Update module version
env:
  MODULE_REPO_TAG: v1.2.0

# Step 2: Add new resources to config
azure_data_factory:
  etl-prod:
    resource_group_name: ref:azure_resource_groups.data.name
    data_factory_name: etl-prod-factory
    location: westeurope
    tags: ref:azure_resource_groups.data.tags

# Step 3: Test in dev
# Step 4: Deploy to staging
# Step 5: Deploy to prod
```

### Scenario: Resource Parameter Changed (Breaking)

**Release Notes**: "BREAKING CHANGE: `account_type` renamed to `sku_name`"

```yaml
# OLD CONFIG (v1.0.0)
azure_storage_accounts:
  data:
    account_type: Premium_LRS

# NEW CONFIG (per release notes)
azure_storage_accounts:
  data:
    sku_name: Premium_LRS  # renamed field

# Update module version and test plan
```

### Scenario: Attributes Rearranged (Compatible)

**Release Notes**: "Reorganized storage account attributes for clarity (no config changes needed)"

```yaml
# Config stays the same across all versions
# Just update module version and deploy
env:
  MODULE_REPO_TAG: v1.1.0  # from v1.0.0

# No config changes necessary
```

---

## Safe Upgrade General Pattern

```
1. Read Release Notes
   ↓
2. Check for Breaking Changes
   ↓
3. Patch or Minor?       Major or Pre-Release?
   └─ Update version    └─ Read closely, plan new config
   └─ Test in dev       └─ Test thoroughly with config
   └─ Deploy to prod    └─ Approval from team lead
                        └─ Deploy cautiously
   ↓
4. Create Upgrade PR
   - Update MODULE_REPO_TAG
   - Update config if needed
   - Reference release notes
   ↓
5. Review & Approve
   - Check plan for accuracy
   - Verify breaking changes addressed
   - Get peer review
   ↓
6. Deploy
   - dev → staging → prod (if applicable)
   - Monitor for errors
   ↓
7. Done!
   - Update internal docs
   - Notify team of new version
```

---

## Emergency Downgrade

If a version causes critical issues:

1. **Identify the issue** via logs
2. **Document the problem** (for module maintainers)
3. **Revert workflow** to previous version:
   ```yaml
   env:
     MODULE_REPO_TAG: v1.0.0  # back to known good
   ```
4. **Run config revert PR**:
   ```bash
   git revert <breaking-commit>
   ```
5. **Apply immediately**:
   ```bash
   # Merge revert PR to main
   # Workflow automatically applies
   ```
6. **Report issue** to module repo:
   - GitHub Issues with reproduction steps
   - Plan output that shows problem
   - Azure errors from Activity Log

---

## Version Compatibility Matrix

| Module Version | terraform | rest provider | azurerm | Supported |
|---|---|---|---|---|
| v1.0.0 | 1.14+ | 1.0+ | 3.50+ | ✅ |
| v1.1.0 | 1.14+ | 1.0+ | 3.50+ | ✅ |
| v2.0.0 | 1.15+ | 1.0.1+ | 3.60+ | ✅ (breaking) |

---

## Getting Help

- **Upgrade questions**: Check module repo [Discussions](../../../discussions)
- **Version compatibility**: See [Releases](../../../releases) page
- **Issues after upgrade**: Open [GitHub Issue](../../../issues) with:
  - Previous version number
  - New version number
  - Terraform plan output (sanitized)
  - Error messages from logs
- **Config questions**: Refer to [CONSUMER_DOCUMENTATION.md](CONSUMER_DOCUMENTATION.md)

---

## FAQ

**Q: When should I upgrade?**  
A: Patch versions immediately. Minor whenever convenient. Major after planning & testing.

**Q: What if my config is incompatible with v2.0.0?**  
A: Stay on v1.x until you can update config. Module repo may backport critical fixes to v1.x.

**Q: Can I skip versions (v1.0.0 → v2.0.0 directly)?**  
A: Yes, but read all release notes between versions for cumulative breaking changes.

**Q: How long is a version supported?**  
A: Latest version only. Previous major version receives critical security patches. See releases page.

**Q: What if a pre-release breaks my dev environment?**  
A: Immediately downgrade and report issue to module repo.

**Q: Should I use floating tags like `@main`?**  
A: **No**. Always pin to specific versions (`@v1.0.0`) to prevent unplanned breaks.
