# Source: Microsoft Graph API
#   api        : Microsoft Graph v1.0
#   resource   : group members
#   create     : POST   /v1.0/groups/{group-id}/members/$ref  (synchronous)
#   delete     : DELETE /v1.0/groups/{group-id}/members/{member-id}/$ref
#
# Group membership is a reference link, not a standalone resource with its own
# identity. We use rest_resource with explicit create/read/delete paths.
# The read path uses the group's members list — the provider will check if
# the member is present. We use rest_operation because:
#  - There is no GET for a single member ref
#  - The POST body has @odata.id, not a standard resource body
#  - We need custom delete path with member ID

resource "rest_resource" "group_member" {
  path          = "/v1.0/groups/${var.group_id}/members/$ref"
  create_method = "POST"

  # There is no direct GET for a single member reference.
  # Use the member's directoryObject endpoint as a read check.
  read_path   = "/v1.0/directoryObjects/${var.member_id}"
  delete_path = "/v1.0/groups/${var.group_id}/members/${var.member_id}/$ref"

  body = {
    "@odata.id" = "https://graph.microsoft.com/v1.0/directoryObjects/${var.member_id}"
  }

  # Poll after creation to verify membership is visible via the directory object.
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
  ])
}
