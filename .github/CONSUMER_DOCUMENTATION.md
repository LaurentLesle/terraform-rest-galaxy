# Module Consumer Documentation

This document is for **configuration repository maintainers** who consume this module repo for their infrastructure deployments.

## Quick Start

### 1. Create Config Repository

Create a new repository to hold your infrastructure configurations:

```bash
git init my-org-infrastructure
cd my-org-infrastructure
```

### 2. Create First Config

```yaml
# configurations/env-prod/config.yaml
terraform_backend:
  type: azurerm
  storage_account_name: tfstateprod
  container_name: terraform
  key: myorg/prod/westeurope/core-infra/terraform.tfstate
  resource_group_name: rg-terraform-state-prod

subscription_id: "12345678-1234-1234-1234-123456789012"

azure_resource_groups:
  core:
    subscription_id: "12345678-1234-1234-1234-123456789012"
    name: rg-myorg-prod-core
    location: westeurope
    tags:
      environment: prod
      managed_by: terraform

azure_storage_accounts:
  data:
    subscription_id: "12345678-1234-1234-1234-123456789012"
    resource_group_name: ref:azure_resource_groups.core.name
    account_name: myorgdata001
    sku_name: Standard_GRS
    kind: StorageV2
    location: ref:azure_resource_groups.core.location
    https_only: true
    tags: ref:azure_resource_groups.core.tags
```

### 3. Create Deployment Workflow

```yaml
# .github/workflows/deploy.yml
name: Deploy Infrastructure

on:
  pull_request:
    paths:
      - configurations/**
      - .github/workflows/deploy.yml
  push:
    branches: [main]
    paths:
      - configurations/**

env:
  MODULE_REPO_TAG: v1.0.0  # Pin to specific release

jobs:
  plan:
    if: github.event_name == 'pull_request'
    uses: <owner>/<module-repo>/.github/workflows/deploy.yml@${{ env.MODULE_REPO_TAG }}
    with:
      config_file: configurations/env-prod/config.yaml
      action: plan
      environment: prod
      module_version: ${{ env.MODULE_REPO_TAG }}
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID_PROD }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID_PROD }}

  apply:
    if: github.event_name == 'push' && github.ref == 'refs/heads/main'
    needs: plan
    uses: <owner>/<module-repo>/.github/workflows/deploy.yml@${{ env.MODULE_REPO_TAG }}
    with:
      config_file: configurations/env-prod/config.yaml
      action: apply
      environment: prod
      module_version: ${{ env.MODULE_REPO_TAG }}
    secrets:
      AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID_PROD }}
      AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
      AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID_PROD }}
```

### 4. Set Up GitHub Secrets

```bash
# For production environment
gh secret set AZURE_CLIENT_ID_PROD --body "<federated-identity-client-id>"
gh secret set AZURE_TENANT_ID --body "<tenant-id>"
gh secret set AZURE_SUBSCRIPTION_ID_PROD --body "<subscription-id>"

# Set GitHub Environment for approval gates
# Settings → Environments → Create "prod" → Add required reviewers
```

### 5. Test Configuration

```bash
# Create PR with config changes
# Workflow runs plan automatically
# Review plan comment on PR
# Merge to apply

# Or test locally:
git clone <module-repo>
cd <module-repo>
TOKEN=$(az account get-access-token --resource https://management.azure.com --query accessToken -o tsv)
TF_CI_MODE=true TF_VAR_azure_access_token="$TOKEN" \
  TF_VAR_subscription_id=$(az account show --query id -o tsv) \
  ./tf.sh plan /path/to/config.yaml
```

---

## Configuration Schema

### Required: terraform_backend

```yaml
terraform_backend:
  type: azurerm  # or: local, gcs, s3
  
  # For azurerm only:
  storage_account_name: tfstate
  container_name: terraform
  key: <org>/<env>/<region>/<workload>/terraform.tfstate
  resource_group_name: rg-terraform-state
```

**State key format**: `<org>/<env>/<region>/<workload>/terraform.tfstate`
- `<org>`: Organization or customer name (lowercase, no spaces)
- `<env>`: `dev`, `staging`, or `prod`
- `<region>`: Azure region code (`westeurope`, `eastus2`, `uksouth`)
- `<workload>`: Workload name (`core-infra`, `aks-cluster`, `data-pipeline`)

**Example**: `acme/prod/westeurope/core-infra/terraform.tfstate`

### Required: subscription_id & azure_resource_groups

```yaml
subscription_id: "12345678-1234-1234-1234-123456789012"

azure_resource_groups:
  core:
    subscription_id: (same as above)
    name: rg-myorg-prod-core
    location: westeurope
    tags:
      environment: prod
```

### Optional: Other Azure Resources

Add any supported Azure resources as root-level keys:

- `azure_storage_accounts`
- `azure_data_lake_store_gen2_file_systems`
- `azure_managed_clusters`
- `azure_key_vaults`
- `azure_postgresql_flexible_servers`
- etc. (all modules in `modules/azure/`)

### Optional: Entra ID Resources

If using Entra ID (Microsoft Graph):

```yaml
entraid_groups:
  platform-admins:
    display_name: "Platform Admins"
    description: "Platform administration group"
    mail_nickname: "platform-admins"

entraid_users:
  jane-admin:
    user_principal_name: "jane@myorg.com"
    display_name: "Jane Admin"
```

### Optional: Remote State References

Reference outputs from other stacks:

```yaml
terraform_backend:
  type: azurerm
  storage_account_name: tfstate
  container_name: terraform
  key: myorg/prod/westeurope/platform/terraform.tfstate
  resource_group_name: rg-terraform-state
  
  remote_states:
    bootstrap:
      type: azurerm
      storage_account_name: tfstate
      container_name: terraform
      key: myorg/prod/westeurope/bootstrap/terraform.tfstate
      resource_group_name: rg-terraform-state
```

In Terraform:
```hcl
data "terraform_remote_state" "bootstrap" {
  backend = "azurerm"
  config = {
    storage_account_name = var.remote_state_backend.storage_account_name
    container_name       = var.remote_state_backend.container_name
    key                  = var.remote_state_keys["bootstrap"]
    resource_group_name  = var.remote_state_backend.resource_group_name
  }
}

locals {
  bootstrap_vnet_id = data.terraform_remote_state.bootstrap.outputs.vnet_id
}
```

---

## Deployment Workflow

### 1. Create Pull Request with Config Change

```yaml
# configurations/env-prod/config.yaml
azure_storage_accounts:
  data:
    account_name: myorgdata002  # Changed from myorgdata001
```

```bash
git checkout -b feature/add-storage
# Edit config.yaml
git commit -am "Add data storage account"
git push origin feature/add-storage
# Create PR
```

### 2. Workflow: Plan Phase

- Triggered: On PR
- Action: `plan`
- Output: Plan artifact + comment on PR

**In GitHub PR**:
```
## Terraform Plan Summary

Environment: prod
Config: configurations/env-prod/config.yaml
State Key: myorg/prod/westeurope/platform/terraform.tfstate

Plan Results
- To add: 1
- To change: 0
- To destroy: 0

Action: Download terraform-plan artifact to review
```

### 3. Review & Approve

- Team reviews plan summary
- Clicks "Approve and merge" (requires required reviewers for prod)
- PR merged to main

### 4. Workflow: Apply Phase

- Triggered: On merge to main
- Action: `apply`
- Requires: GitHub Environment approval (e.g., "prod")

**In GitHub Actions**:
- Waits for approval from designated reviewer
- Reviewer approves
- Terraform apply runs with exact saved plan
- State updated in Azure Storage

### 5. Deployment Complete

- Terraform outputs published
- Deployment metadata artifact created (actor, timestamp, module version)
- Resources available on Azure

---

## Workflow Inputs & Outputs

### Workflow Call Interface

```yaml
uses: <owner>/<module-repo>/.github/workflows/deploy.yml@v1.0.0
with:
  config_file: configurations/env-prod/config.yaml
  action: plan  # 'plan', 'apply', or 'destroy'
  environment: prod  # 'dev', 'staging', 'prod'
  module_version: v1.0.0
  terraform_version: "1.14.5"  # optional
  plan_artifact_name: terraform-plan  # optional
secrets:
  AZURE_CLIENT_ID: ${{ secrets.AZURE_CLIENT_ID_PROD }}
  AZURE_TENANT_ID: ${{ secrets.AZURE_TENANT_ID }}
  AZURE_SUBSCRIPTION_ID: ${{ secrets.AZURE_SUBSCRIPTION_ID_PROD }}
```

### Workflow Outputs

After workflow completes:

```yaml
${{ needs.<job-name>.outputs.plan_summary }}
# Example:
# {"to_add": 5, "to_change": 2, "to_destroy": 0, "error": null}

${{ needs.<job-name>.outputs.state_key }}
# Example: myorg/prod/westeurope/core-infra/terraform.tfstate

${{ needs.<job-name>.outputs.deployment_id }}
# Example: abc123def-1712504200

${{ needs.<job-name>.outputs.apply_status }}
# Example: success | failed | not_run
```

---

## Multi-Environment Setup

### Repository Structure

```
my-org-infrastructure/
├── .github/
│   └── workflows/
│       └── deploy.yml         (single workflow, calls module repo per env)
├── configurations/
│   ├── env-dev/config.yaml
│   ├── env-staging/config.yaml
│   └── env-prod/config.yaml
├── README.md
└── CHANGELOG.md
```

### Workflow Pattern

Different configs per environment, single workflow:

```yaml
# .github/workflows/deploy.yml
jobs:
  plan-dev:
    if: (PR to main with dev config changes)
    uses: <owner>/<module-repo>/.github/workflows/deploy.yml@v1.0.0
    with:
      config_file: configurations/env-dev/config.yaml
      environment: dev

  plan-prod:
    if: (PR to main with prod config changes)
    uses: <owner>/<module-repo>/.github/workflows/deploy.yml@v1.0.0
    with:
      config_file: configurations/env-prod/config.yaml
      environment: prod

  apply-prod:
    if: (push to main in prod environment)
    needs: plan-prod
    uses: <owner>/<module-repo>/.github/workflows/deploy.yml@v1.0.0
    with:
      config_file: configurations/env-prod/config.yaml
      action: apply
      environment: prod
```

---

## Version Management

### Pinning Module Versions

**Always pin to a specific release tag**:

```yaml
# ✅ Good: Pinned version
uses: <owner>/<module-repo>/.github/workflows/deploy.yml@v1.0.0

# ❌ Bad: Floating version (breaking changes possible)
uses: <owner>/<module-repo>/.github/workflows/deploy.yml@main
```

### Upgrading Versions

1. **Check release notes** for breaking changes
2. **Update environment variable** in workflow:
   ```yaml
   env:
     MODULE_REPO_TAG: v1.1.0  # from v1.0.0
   ```
3. **Test in dev environment first**
4. **Roll out to staging, then prod**

See [VERSION_UPGRADE_GUIDE.md](VERSION_UPGRADE_GUIDE.md) for detailed steps.

---

## Troubleshooting

### Error: "Config file not found"

**Cause**: Path mismatch between config repo structure  
**Solution**: Verify config file path matches actual file location

```bash
ls -la configurations/env-prod/config.yaml
```

### Error: "Invalid state key format"

**Cause**: State key doesn't match naming convention  
**Solution**: Use format `<org>/<env>/<region>/<workload>/terraform.tfstate`

```yaml
# ❌ Wrong
key: env-prod/state.tfstate

# ✅ Right
key: myorg/prod/westeurope/core-infra/terraform.tfstate
```

### Error: "terraform_backend not found"

**Cause**: YAML config missing `terraform_backend` section  
**Solution**: Add backend configuration

```yaml
terraform_backend:
  type: azurerm
  storage_account_name: tfstate
  container_name: terraform
  key: myorg/prod/westeurope/core-infra/terraform.tfstate
  resource_group_name: rg-terraform-state
```

### Plan looks wrong or incomplete

**Cause**: Config references stale state or missing backends  
**Solution**: Verify Azure credentials and state file exists

```bash
az storage blob exists \
  --account-name tfstate \
  --container-name terraform \
  --name myorg/prod/westeurope/core-infra/terraform.tfstate
```

### Workflow approval stuck

**Cause**: GitHub Environment approval requirement not met  
**Solution**: Check GitHub Settings → Environments → Environment name → Required reviewers

---

## Best Practices

### 1. Use Configuration Management

- Keep configs **version controlled** (git)
- **Review all changes** via PR
- **Require approvals** for production configs
- **Tag releases** when applying to prod

### 2. State Management

- **One state file per stack** (use state key hierarchy)
- **Separate subscriptions** for dev/staging/prod
- **Back up state** regularly
- **Audit all state changes** (Terraform Cloud / Sentinel optional)

### 3. Team Workflow

- **Code owners**: Define who can approve prod deploys
  ```
  # CODEOWNERS
  configurations/env-prod/ @platform-team
  ```
- **Branch protection**: Require PR review + CI check
- **Environment approval**: Require manual approval for prod

### 4. Monitoring & Alerting

- **Monitor deployment status** via GitHub Actions
- **Subscribe to release notifications** in module repo
- **Check Azure Activity Log** for resource changes
- **Set up cost alerts** for unexpected resource creation

### 5. Documentation

- **Document config patterns** in your README
- **Keep changelog** of config changes
- **Document custom policies** (naming conventions, tags)
- **Link to module repo docs** for consumers

---

## References

- [Backend Interface Contract](../BACKEND_INTERFACE_CONTRACT.md) — State, naming, requirements
- [CI vs CD Workflows](../CI_vs_CD.md) — How tests and deployments work
- [Module Repo Releases](https://github.com/<owner>/<module-repo>/releases) — Available versions
- [Azure REST API Docs](https://docs.microsoft.com/azure/developer/terraform/) — Resource docs
- [Terraform Documentation](https://www.terraform.io/docs) — Terraform language reference

---

## Getting Help

- **Questions about configs**: Check [Backend Interface Contract](../BACKEND_INTERFACE_CONTRACT.md)
- **Version upgrade help**: See [VERSION_UPGRADE_GUIDE.md](VERSION_UPGRADE_GUIDE.md)
- **CI/CD workflow issues**: Review [CI vs CD Workflows](../CI_vs_CD.md)
- **Terraform errors**: Check module repo [GitHub Issues](https://github.com/<owner>/<module-repo>/issues)
- **Azure resource questions**: Refer to [Azure REST API docs](https://docs.microsoft.com/rest/api/azure/)

---

## Support & Feedback

- **Bug reports**: Open issue in module repo
- **Feature requests**: Discuss in module repo discussions
- **Version compatibility**: Check module repo releases & tags
- **Custom modules**: Fork module repo and adapt for your needs
