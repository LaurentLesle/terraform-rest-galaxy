# YAML Reference — GitHub

← [Back to index](yaml-reference.md)

### `github_environment_secrets`

**API version:** `GitHub REST API v2022-11-28`

Map of GitHub Actions secrets scoped to a specific deployment environment.
Encrypted with NaCl sealed-box using the environment's public key.

Requires var.github_token with repo scope.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `owner` | `string` | yes | — |  |
| `repo` | `string` | yes | — |  |
| `environment_name` | `string` | yes | — |  |
| `secret_name` | `string` | yes | — |  |
| `plaintext_value` | `string` | yes | — |  |

#### YAML Example

```yaml
github_environment_secrets:
  staging_api_key:
    owner: "my-org"
    repo: "acme-demo-app"
    environment_name: "staging"
    secret_name: "API_KEY"
    plaintext_value: "..."
```

---

### `github_environments`

**API version:** `GitHub REST API v2022-11-28`

Map of GitHub deployment environments to create via the GitHub REST API.
Each environment is created with PUT /repos/{owner}/{repo}/environments/{name}
which is idempotent. Optional wait_timer, reviewers, and
deployment_branch_policy control job protection rules.

Requires var.github_token with repo scope.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `owner` | `string` | yes | — |  |
| `repo` | `string` | yes | — |  |
| `name` | `string` | yes | — |  |
| `wait_timer` | `number` | no | `null` |  |
| `prevent_self_review` | `bool` | no | `null` |  |
| `reviewers` | `list(object)` | no | `null` |  |
| `deployment_branch_policy` | `object` | no | `null` |  |

#### YAML Example

```yaml
github_environments:
  acme_demo_production:
    owner: "my-org"
    repo: "acme-demo-app"
    name: "production"
    wait_timer: 5
    reviewers: [{ type = "Team", id = 12345 }]
```

---

### `github_hosted_runners`

**API version:** `GitHub REST API v2022-11-28`

Map of GitHub-hosted runners to create via the GitHub REST API.
Each runner is placed in a runner group (which may have network
configuration for VNet injection).

Requires var.github_token with manage_runners:org scope.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `organization` | `string` | yes | — |  |
| `name` | `string` | yes | — |  |
| `image_id` | `string` | no | `"ubuntu-24.04"` |  |
| `image_source` | `string` | no | `"github"` |  |
| `size` | `string` | no | `"4-core"` |  |
| `runner_group_id` | `number` | yes | — |  |
| `maximum_runners` | `number` | no | `null` |  |
| `enable_static_ip` | `bool` | no | `null` |  |

#### YAML Example

```yaml
github_hosted_runners:
  linux_4core:
    organization: "my-org"
    name: "linux-4core-vnet"
    image_id: "ubuntu-24.04"
    size: "4-core"
    runner_group_id: 12345
    maximum_runners: 10
```

---

### `github_organization_secrets`

**API version:** `GitHub REST API v2022-11-28`

Map of GitHub Actions secrets scoped to an entire organization. Shared
across all repositories selected by var.visibility. Encrypted with NaCl
sealed-box using the organization's public key.

Requires var.github_token with admin:org scope.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `organization` | `string` | yes | — |  |
| `secret_name` | `string` | yes | — |  |
| `plaintext_value` | `string` | yes | — |  |
| `visibility` | `string` | yes | — |  |
| `selected_repository_ids` | `list(number)` | no | `null` |  |

#### YAML Example

```yaml
github_organization_secrets:
  shared_npm_token:
    organization: "my-org"
    secret_name: "NPM_TOKEN"
    plaintext_value: "..."
    visibility: "all"
```

---

### `github_repositories`

**API version:** `GitHub REST API v2022-11-28`

Map of GitHub repositories to create via the GitHub REST API under an
existing organization.

Requires var.github_token with repo + admin:org scope.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `organization` | `string` | yes | — |  |
| `name` | `string` | yes | — |  |
| `check_existance` | `bool` | no | `false` |  |
| `description` | `string` | no | `null` |  |
| `homepage` | `string` | no | `null` |  |
| `visibility` | `string` | no | `"private"` |  |
| `auto_init` | `bool` | no | `false` |  |
| `gitignore_template` | `string` | no | `null` |  |
| `license_template` | `string` | no | `null` |  |
| `has_issues` | `bool` | no | `null` |  |
| `has_projects` | `bool` | no | `null` |  |
| `has_wiki` | `bool` | no | `null` |  |
| `has_downloads` | `bool` | no | `null` |  |
| `delete_branch_on_merge` | `bool` | no | `null` |  |
| `allow_squash_merge` | `bool` | no | `null` |  |
| `allow_merge_commit` | `bool` | no | `null` |  |
| `allow_rebase_merge` | `bool` | no | `null` |  |
| `allow_auto_merge` | `bool` | no | `null` |  |

#### YAML Example

```yaml
github_repositories:
  acme_demo_app:
    organization: "my-org"
    name: "acme-demo-app"
    description: "Demo app managed by terraform-rest-galaxy"
    visibility: "private"
    auto_init: true
```

---

### `github_repository_secrets`

**API version:** `GitHub REST API v2022-11-28`

Map of GitHub Actions repository secrets to create via the GitHub REST API.
Secret values are encrypted at plan time using NaCl sealed-box encryption
(provider::rest::nacl_seal) with the repository's public key.

Requires var.github_token with repo scope.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `owner` | `string` | yes | — |  |
| `repo` | `string` | yes | — |  |
| `secret_name` | `string` | yes | — |  |
| `plaintext_value` | `string` | yes | — |  |

#### YAML Example

```yaml
github_repository_secrets:
  azure_client_id:
    owner: "my-org"
    repo: "my-repo"
    secret_name: "AZURE_CLIENT_ID"
    plaintext_value: "00000000-0000-0000-0000-000000000000"
```

---

### `github_runner_groups`

**API version:** `GitHub REST API v2022-11-28`

Map of GitHub Actions runner groups to create via the GitHub REST API.
Each runner group can optionally reference a GitHub.Network/networkSettings
resource for VNet injection.

Requires var.github_token with admin:org scope.

#### Attributes

| Name | Type | Required | Default | Description |
|------|------|:--------:|---------|-------------|
| `organization` | `string` | yes | — |  |
| `name` | `string` | yes | — |  |
| `visibility` | `string` | no | `"all"` |  |
| `allows_public_repositories` | `bool` | no | `false` |  |
| `restricted_to_workflows` | `bool` | no | `false` |  |
| `selected_workflows` | `list(string)` | no | `null` |  |
| `network_configuration_id` | `string` | no | `null` |  |

#### YAML Example

```yaml
github_runner_groups:
  azure_runners:
    organization: "my-org"
    name: "azure-vnet-runners"
    visibility: "all"
    network_configuration_id: "ref:azure_github_network_settings.runners.id"
```

---
