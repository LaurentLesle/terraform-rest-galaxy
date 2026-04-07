# Source: GitHub REST API
#   api        : GitHub REST API v2022-11-28
#   resource   : actions/secrets
#   public_key : GET    /repos/{owner}/{repo}/actions/secrets/public-key
#   create     : PUT    /repos/{owner}/{repo}/actions/secrets/{secret_name}  (synchronous)
#   read       : GET    /repos/{owner}/{repo}/actions/secrets/{secret_name}
#   delete     : DELETE /repos/{owner}/{repo}/actions/secrets/{secret_name}
#
# The GitHub Secrets API requires that the secret value is encrypted using
# NaCl sealed-box encryption (libsodium crypto_box_seal) with the repository's
# public key before upload. The provider::rest::nacl_seal function handles this.

# ── Fetch the repository's NaCl public key ───────────────────────────────────
data "rest_resource" "public_key" {
  id = "/repos/${var.owner}/${var.repo}/actions/secrets/public-key"

  output_attrs = toset([
    "key",
    "key_id",
  ])
}

# ── Encrypt and upload the secret ────────────────────────────────────────────
resource "rest_resource" "secret" {
  path          = "/repos/${var.owner}/${var.repo}/actions/secrets/${var.secret_name}"
  create_method = "PUT"

  read_path   = "/repos/${var.owner}/${var.repo}/actions/secrets/${var.secret_name}"
  delete_path = "/repos/${var.owner}/${var.repo}/actions/secrets/${var.secret_name}"

  body = {
    encrypted_value = provider::rest::nacl_seal(var.plaintext_value, data.rest_resource.public_key.output.key)
    key_id          = data.rest_resource.public_key.output.key_id
  }

  # PUT returns empty body (201/204); GET returns name + created_at + updated_at (no value)
  output_attrs = toset([
    "name",
    "created_at",
    "updated_at",
  ])
}
