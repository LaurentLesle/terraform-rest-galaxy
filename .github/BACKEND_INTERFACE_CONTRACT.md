# Backend Interface Contract

This document defines the **required interface** between configuration files, tf.sh, and the deployment workflow. It ensures safe, reliable state management across environments.

## State Key Naming Convention

All remote state files must follow this hierarchical key format:

```
<organization>/<environment>/<region>/<workload>/terraform.tfstate
```

**Components**:
- `<organization>`: Feature or tenant name (e.g., `customer-acme`, `acme`)
- `<environment>`: Deployment tier (`dev`, `staging`, `prod`)
- `<region>`: Azure region short code (`westeurope`, `eastus2`, `uksouth`)
- `<workload>`: Workload name (`core-infra`, `aks-cluster`, `data-pipeline`)

**Examples**:
```
acme/dev/westeurope/core-infra/terraform.tfstate
acme/prod/westeurope/core-infra/terraform.tfstate
acme/prod/eastus2/secondary/terraform.tfstate
acme/staging/westeurope/github-runners/terraform.tfstate
```

This structure enables:
- Easy discovery of state files across environments
- Clear ownership and purpose
- Multi-region deployments without conflicts
- Audit trail of deployments

---

## azurerm Backend Requirements

All production deployments use Azure Storage as remote backend.

### Required Parameters

```yaml
terraform_backend:
  type: azurerm
  storage_account_name: "tfstate0001"      # Must exist before deployment
  container_name: "terraform"               # Must exist before deployment
  key: "acme/prod/westeurope/core/terraform.tfstate"  # Must follow naming convention
  resource_group_name: "rg-terraform-state"
```

### Validation Rules

| Parameter | Required | Validation | Failure Mode |
|-----------|----------|-----------|--------------|
| `type` | ✅ | Must be `"azurerm"` for prod | tf.sh exits with error |
| `storage_account_name` | ✅ | 3-24 chars, alphanumeric only | tf.sh exits with error |
| `container_name` | ✅ | Must exist in Azure Storage | terraform init fails |
| `key` | ✅ | Must match naming convention (see above) | Deploy workflow rejects in plan phase |
| `resource_group_name` | ✅ | Must exist in subscription | terraform init fails |

### Example: Production Config

```yaml
terraform_backend:
  type: azurerm
  storage_account_name: tfstateprod
  container_name: terraform
  key: acme/prod/westeurope/core-infra/terraform.tfstate
  resource_group_name: rg-terraform-state-prod

subscription_id: "12345678-1234-1234-1234-123456789012"
```

### Example: Local Development Config

```yaml
terraform_backend:
  type: local
```

---

## Remote State References

For deployments that reference state from other stacks (e.g., reading outputs from a bootstrap stack), define:

```yaml
terraform_backend:
  type: azurerm
  storage_account_name: tfstate
  container_name: terraform
  key: acme/prod/westeurope/core-infra/terraform.tfstate
  
  remote_states:
    bootstrap:
      type: azurerm
      storage_account_name: tfstate
      container_name: terraform
      key: acme/prod/westeurope/bootstrap/terraform.tfstate
    
    shared:
      type: azurerm
      storage_account_name: tfstate
      container_name: terraform
      key: acme/prod/westeurope/shared/terraform.tfstate
```

**Usage in Terraform**:
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

## tf.sh Output Guarantees

When run with `TF_CI_MODE=true`, tf.sh guarantees:

### Always Written to stdout/stderr
- Status messages with emoji indicator (✓, ✗, ▸, ⚠)
- Terraform output (plan/apply/destroy)
- Errors with context and remediation steps

### Always Exported Environment Variables
When action completes successfully, these are set:
- `TF_VAR_azure_access_token` — ARM token (if needed)
- `TF_VAR_subscription_id` — Subscription ID
- `TF_VAR_graph_access_token` — Graph token (if needed)

### Terraform Commands Run in Order
1. `terraform validate`
2. `terraform plan` / `terraform apply` / `terraform destroy`
3. State upload to Azure Storage (bootstrap only)

### Exit Codes

| Exit Code | Meaning | Automation Action |
|-----------|---------|-------------------|
| `0` | Success | Continue to next step |
| `1` | Validation/parse error | Fail workflow, show error in logs |
| `1` | Terraform plan failed | Fail workflow, upload plan artifact for review |
| `1` | Terraform apply failed | Fail workflow, preserve state, alert operator |

---

## Deploy Workflow Backend Contract

The deploy workflow ([.github/workflows/deploy.yml](.github/workflows/deploy.yml)) enforces:

### Plan Phase

1. **Parse Config YAML** → Extract `terraform_backend`
2. **Validate State Key** → Must match naming convention: `^[a-z0-9-]+/[a-z0-9]+/[a-z0-9]+/[a-z0-9-]+/terraform\.tfstate$`
3. **Check Required Fields** → All parameters present
4. **Run terraform init** → Fails if storage account unreachable
5. **Run terraform plan** → Generate execution plan
6. **Upload Plan Artifact** → For approval and apply phase

### Apply Phase

1. **Download Plan Artifact** → From plan phase (audit trail)
2. **Validate Artifact Integrity** → Must contain plan.tfplan + plan_summary.json
3. **Re-authenticate** → Fresh OIDC tokens
4. **Run terraform apply** → Apply exact saved plan
5. **Emit Metadata** → Deployment ID, actor, timestamp, state key

---

## Multi-Environment State Isolation

Each environment (dev/staging/prod) **must use**:

1. **Separate Azure subscriptions** (recommended) OR
2. **Separate resource groups** AND **separate storage accounts** (minimum)

### Recommended: Separate Subscriptions

```yaml
# Dev: different subscription
terraform_backend:
  type: azurerm
  storage_account_name: tfstatedev
  container_name: terraform
  key: acme/dev/westeurope/core-infra/terraform.tfstate
  resource_group_name: rg-terraform-state

---

# Prod: locked-down subscription
terraform_backend:
  type: azurerm
  storage_account_name: tfstateprod
  container_name: terraform
  key: acme/prod/westeurope/core-infra/terraform.tfstate
  resource_group_name: rg-terraform-state-prod
```

### Why This Matters

- **Prevents accidental prod changes** — Separate OIDC identities per subscription
- **Audit trail** — State changes attributed to environment-specific identity
- **Cost tracking** — Azure billing tracks by subscription
- **Compliance** — Production state isolated from development

---

## Backend Secrets & OIDC

### No Secrets in Code

Backend parameters in YAML are **NOT secrets**:
- Storage account name ✅ public
- Container name ✅ public
- State key path ✅ public
- Resource group name ✅ public

### Authentication via OIDC

Access to storage account is controlled via:
- **Federated OIDC identity** (GitHub Actions → Azure)
- **RBAC role** (`Storage Blob Data Contributor` on storage account)
- **No static storage keys** in code or secrets

Example RBAC:
```bash
# Grant GitHub OIDC identity access to prod storage account
az role assignment create \
  --role "Storage Blob Data Contributor" \
  --assignee-object-id <federated-identity-object-id> \
  --scope /subscriptions/<sub-id>/resourceGroups/rg-terraform-state-prod/providers/Microsoft.Storage/storageAccounts/tfstateprod
```

---

## Troubleshooting Backend Issues

### "No terraform_backend section in config"

**Cause**: YAML config missing `terraform_backend` block  
**Fix**: Add to config:
```yaml
terraform_backend:
  type: local  # for dev
  # OR
  type: azurerm
  storage_account_name: tfstate
  container_name: terraform
  key: acme/dev/westeurope/core-infra/terraform.tfstate
  resource_group_name: rg-terraform-state
```

### "Error acquiring state lock"

**Cause**: Blob lease already held (previous apply interrupted)  
**Fix**:
```bash
./tf.sh force-unlock configurations/env-prod/config.yaml
```

### "Container not found in storage account"

**Cause**: Blob container doesn't exist in Azure Storage  
**Fix**:
```bash
az storage container create \
  --name terraform \
  --account-name tfstate \
  --auth-mode key  # or login
```

### State Key Validation Failed in Deploy Workflow

**Cause**: Key doesn't match naming convention  
**Fix**: Update config key to match: `^<org>/<env>/<region>/<workload>/terraform\.tfstate$`

---

## Migration Path

Existing deployments using non-standard state keys can be migrated:

```bash
# 1. List current state
terraform state list

# 2. Export state
terraform state pull > old-state.json

# 3. Create new state file in new location (rename key in backend.tf)
terraform init  # recreates with new key

# 4. Import old state
terraform state push old-state.json

# 5. Verify resources
terraform plan  # should show no changes
```

---

## References

- [CICD Roadmap](.github/CICD_ROADMAP.md)
- [CI vs CD](.github/CI_vs_CD.md)
- [tf.sh Script](../tf.sh)
- [Deploy Workflow](.github/workflows/deploy.yml)
