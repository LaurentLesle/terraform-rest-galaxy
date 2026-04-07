# ── GitHub Repository Secrets ─────────────────────────────────────────────────

variable "github_repository_secrets" {
  type = map(object({
    owner           = string
    repo            = string
    secret_name     = string
    plaintext_value = string
  }))
  description = <<-EOT
    Map of GitHub Actions repository secrets to create via the GitHub REST API.
    Secret values are encrypted at plan time using NaCl sealed-box encryption
    (provider::rest::nacl_seal) with the repository's public key.

    Requires var.github_token with repo scope.

    Example:
      github_repository_secrets = {
        azure_client_id = {
          owner           = "my-org"
          repo            = "my-repo"
          secret_name     = "AZURE_CLIENT_ID"
          plaintext_value = "00000000-0000-0000-0000-000000000000"
        }
      }
  EOT
  default     = {}
}

locals {
  github_repository_secrets = provider::rest::resolve_map(
    local._ctx_l3,
    merge(try(local._yaml_raw.github_repository_secrets, {}), var.github_repository_secrets)
  )
}

module "github_repository_secrets" {
  source   = "./modules/github/repository_secret"
  for_each = local.github_repository_secrets

  providers = {
    rest = rest.github
  }

  depends_on = [module.azure_user_assigned_identities]

  owner           = each.value.owner
  repo            = each.value.repo
  secret_name     = each.value.secret_name
  plaintext_value = each.value.plaintext_value
}
