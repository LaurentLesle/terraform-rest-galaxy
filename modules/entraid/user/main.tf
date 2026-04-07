# Source: Microsoft Graph API
#   api        : Microsoft Graph v1.0
#   resource   : users
#   create     : POST   /v1.0/users  (synchronous, server-assigned id)
#   read       : GET    /v1.0/users/{id}
#   update     : PATCH  /v1.0/users/{id}
#   delete     : DELETE /v1.0/users/{id}
#
# NOTE: This module requires a rest provider configured with
#   base_url = "https://graph.microsoft.com"
# and a token scoped to https://graph.microsoft.com/.default

locals {
  password_profile = {
    password                             = var.password_profile.password
    forceChangePasswordNextSignIn        = var.password_profile.force_change_password_next_sign_in
    forceChangePasswordNextSignInWithMfa = var.password_profile.force_change_password_next_sign_in_with_mfa
  }

  body = merge(
    {
      displayName       = var.display_name
      mailNickname      = var.mail_nickname
      userPrincipalName = var.user_principal_name
      accountEnabled    = var.account_enabled
      passwordProfile   = local.password_profile
    },
    var.given_name != null ? { givenName = var.given_name } : {},
    var.surname != null ? { surname = var.surname } : {},
    var.job_title != null ? { jobTitle = var.job_title } : {},
    var.department != null ? { department = var.department } : {},
    var.office_location != null ? { officeLocation = var.office_location } : {},
    var.city != null ? { city = var.city } : {},
    var.country != null ? { country = var.country } : {},
    var.state != null ? { state = var.state } : {},
    var.postal_code != null ? { postalCode = var.postal_code } : {},
    var.street_address != null ? { streetAddress = var.street_address } : {},
    var.company_name != null ? { companyName = var.company_name } : {},
    var.mobile_phone != null ? { mobilePhone = var.mobile_phone } : {},
    var.preferred_language != null ? { preferredLanguage = var.preferred_language } : {},
    var.usage_location != null ? { usageLocation = var.usage_location } : {},
    var.user_type != null ? { userType = var.user_type } : {},
    var.employee_id != null ? { employeeId = var.employee_id } : {},
    var.employee_type != null ? { employeeType = var.employee_type } : {},
    var.other_mails != null ? { otherMails = var.other_mails } : {},
  )
}

resource "rest_resource" "user" {
  path          = "/v1.0/users"
  create_method = "POST"
  update_method = "PATCH"

  read_path   = "/v1.0/users/$(body.id)"
  update_path = "/v1.0/users/$(body.id)"
  delete_path = "/v1.0/users/$(body.id)"

  body = local.body

  # passwordProfile is write-only — not returned by GET
  write_only_attrs = toset([
    "passwordProfile",
  ])

  # Poll after creation to ensure the user is fully readable/replicated
  # before downstream resources (e.g. role assignments, group memberships) reference it.
  poll_create = {
    status_locator    = "code"
    default_delay_sec = 5
    status = {
      success = "200"
      pending = ["404"]
    }
  }

  output_attrs = toset([
    "id",
    "displayName",
    "userPrincipalName",
    "mailNickname",
    "accountEnabled",
    "givenName",
    "surname",
    "jobTitle",
    "department",
    "createdDateTime",
  ])
}
