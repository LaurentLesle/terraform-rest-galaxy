# Source: Microsoft Graph API
#   api        : Microsoft Graph v1.0
#   resource   : servicePrincipals
#   create     : POST   /v1.0/servicePrincipals  (synchronous, server-assigned id)
#   read       : GET    /v1.0/servicePrincipals/{id}
#   delete     : DELETE /v1.0/servicePrincipals/{id}
#
# Registers a service principal (Enterprise Application) in the tenant for a
# given application (client) ID. This is the programmatic equivalent of
# "az ad sp create --id <appId>" or clicking "Grant admin consent" in the portal.

resource "rest_resource" "service_principal" {
  path          = "/v1.0/servicePrincipals"
  create_method = "POST"

  read_path   = "/v1.0/servicePrincipals/$(body.id)"
  delete_path = "/v1.0/servicePrincipals/$(body.id)"

  body = {
    appId = var.app_id
  }

  poll_create = {
    status_locator    = "code"
    default_delay_sec = 10
    status = {
      success = "200"
      pending = ["404"]
    }
  }

  output_attrs = toset([
    "id",
    "appId",
    "displayName",
    "servicePrincipalType",
  ])
}
