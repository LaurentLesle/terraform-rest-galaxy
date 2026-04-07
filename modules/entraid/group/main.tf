# Source: Microsoft Graph API
#   api        : Microsoft Graph v1.0
#   resource   : groups
#   create     : POST   /v1.0/groups  (synchronous, server-assigned id)
#   read       : GET    /v1.0/groups/{id}
#   update     : PATCH  /v1.0/groups/{id}
#   delete     : DELETE /v1.0/groups/{id}
#
# NOTE: This module requires a rest provider configured with
#   base_url = "https://graph.microsoft.com"
# and a token scoped to https://graph.microsoft.com/.default

locals {
  body = merge(
    {
      displayName     = var.display_name
      mailEnabled     = var.mail_enabled
      mailNickname    = var.mail_nickname
      securityEnabled = var.security_enabled
    },
    var.description != null ? { description = var.description } : {},
    var.group_types != null ? { groupTypes = var.group_types } : {},
    var.visibility != null ? { visibility = var.visibility } : {},
    var.is_assignable_to_role != null ? { isAssignableToRole = var.is_assignable_to_role } : {},
    var.membership_rule != null ? { membershipRule = var.membership_rule } : {},
    var.membership_rule_processing_state != null ? { membershipRuleProcessingState = var.membership_rule_processing_state } : {},
  )
}

resource "rest_resource" "group" {
  path          = "/v1.0/groups"
  create_method = "POST"
  update_method = "PATCH"

  read_path   = "/v1.0/groups/$(body.id)"
  update_path = "/v1.0/groups/$(body.id)"
  delete_path = "/v1.0/groups/$(body.id)"

  body = local.body

  # Poll after creation to ensure the group is fully readable/replicated
  # before downstream resources (e.g. role assignments) reference it.
  poll_create = {
    status_locator    = "code"
    default_delay_sec = 30
    status = {
      success = "200"
      pending = ["404"]
    }
  }

  output_attrs = toset([
    "id",
    "displayName",
    "mailEnabled",
    "mailNickname",
    "securityEnabled",
    "groupTypes",
    "visibility",
    "createdDateTime",
  ])
}
