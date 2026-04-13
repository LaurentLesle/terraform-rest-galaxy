# Source: Microsoft Graph API
#   api        : Microsoft Graph v1.0
#   resource   : applications
#   create     : POST   /v1.0/applications  (synchronous, server-assigned id)
#   read       : GET    /v1.0/applications/{id}
#   update     : PATCH  /v1.0/applications/{id}
#   delete     : DELETE /v1.0/applications/{id}
#
# NOTE: This module requires a rest provider configured with
#   base_url = "https://graph.microsoft.com"
# and a token scoped to https://graph.microsoft.com/.default

locals {
  # ── Web settings ─────────────────────────────────────────────────────────
  web = var.web != null ? {
    redirectUris = var.web.redirect_uris
    homePageUrl  = var.web.home_page_url
    logoutUrl    = var.web.logout_url
    implicitGrantSettings = {
      enableAccessTokenIssuance = var.web.implicit_grant_access_tokens
      enableIdTokenIssuance     = var.web.implicit_grant_id_tokens
    }
  } : null

  # ── SPA settings ────────────────────────────────────────────────────────
  spa = var.spa != null ? {
    redirectUris = var.spa.redirect_uris
  } : null

  # ── Public client settings ──────────────────────────────────────────────
  public_client = var.public_client != null ? {
    redirectUris = var.public_client.redirect_uris
  } : null

  # ── API settings ────────────────────────────────────────────────────────
  api = var.api != null ? merge(
    {
      requestedAccessTokenVersion = var.api.requested_access_token_version
    },
    var.api.oauth2_permission_scopes != null ? {
      oauth2PermissionScopes = [for s in var.api.oauth2_permission_scopes : {
        adminConsentDescription = s.admin_consent_description
        adminConsentDisplayName = s.admin_consent_display_name
        id                      = s.id
        isEnabled               = s.is_enabled
        type                    = s.type
        userConsentDescription  = s.user_consent_description
        userConsentDisplayName  = s.user_consent_display_name
        value                   = s.value
      }]
    } : {},
  ) : null

  # ── Required resource access ────────────────────────────────────────────
  required_resource_access = var.required_resource_access != null ? [for ra in var.required_resource_access : {
    resourceAppId = ra.resource_app_id
    resourceAccess = [for a in ra.resource_access : {
      id   = a.id
      type = a.type
    }]
  }] : null

  # ── App roles ───────────────────────────────────────────────────────────
  app_roles = var.app_roles != null ? [for r in var.app_roles : {
    allowedMemberTypes = r.allowed_member_types
    description        = r.description
    displayName        = r.display_name
    id                 = r.id
    isEnabled          = r.is_enabled
    value              = r.value
  }] : null

  # ── Optional claims ─────────────────────────────────────────────────────
  optional_claims = var.optional_claims != null ? merge(
    var.optional_claims.access_token != null ? {
      accessToken = [for c in var.optional_claims.access_token : {
        name                 = c.name
        additionalProperties = c.additional_properties
        essential            = c.essential
        source               = c.source
      }]
    } : {},
    var.optional_claims.id_token != null ? {
      idToken = [for c in var.optional_claims.id_token : {
        name                 = c.name
        additionalProperties = c.additional_properties
        essential            = c.essential
        source               = c.source
      }]
    } : {},
    var.optional_claims.saml2_token != null ? {
      saml2Token = [for c in var.optional_claims.saml2_token : {
        name                 = c.name
        additionalProperties = c.additional_properties
        essential            = c.essential
        source               = c.source
      }]
    } : {},
  ) : null

  # ── Request body ────────────────────────────────────────────────────────
  body = merge(
    {
      displayName    = var.display_name
      signInAudience = var.sign_in_audience
    },
    var.description != null ? { description = var.description } : {},
    var.notes != null ? { notes = var.notes } : {},
    var.identifier_uris != null ? { identifierUris = var.identifier_uris } : {},
    var.tags != null ? { tags = var.tags } : {},
    var.group_membership_claims != null ? { groupMembershipClaims = var.group_membership_claims } : {},
    var.is_fallback_public_client != null ? { isFallbackPublicClient = var.is_fallback_public_client } : {},
    var.is_device_only_auth_supported != null ? { isDeviceOnlyAuthSupported = var.is_device_only_auth_supported } : {},
    local.web != null ? { web = local.web } : {},
    local.spa != null ? { spa = local.spa } : {},
    local.public_client != null ? { publicClient = local.public_client } : {},
    local.api != null ? { api = local.api } : {},
    local.required_resource_access != null ? { requiredResourceAccess = local.required_resource_access } : {},
    local.app_roles != null ? { appRoles = local.app_roles } : {},
    local.optional_claims != null ? { optionalClaims = local.optional_claims } : {},
  )
}

resource "rest_resource" "application" {
  path          = "/v1.0/applications"
  create_method = "POST"
  update_method = "PATCH"

  # After POST, the server assigns an id. Use it for read/update/delete.
  read_path   = "/v1.0/applications/$(body.id)"
  update_path = "/v1.0/applications/$(body.id)"
  delete_path = "/v1.0/applications/$(body.id)"

  body = local.body

  # Poll after creation to ensure the application is fully readable/replicated.
  poll_create = {
    status_locator    = "code"
    default_delay_sec = 5
    status = {
      success = ["200"]
      pending = ["404"]
    }
  }

  output_attrs = toset([
    "id",
    "appId",
    "displayName",
    "signInAudience",
    "publisherDomain",
    "createdDateTime",
    "identifierUris",
    "web",
    "spa",
    "api",
  ])
}
