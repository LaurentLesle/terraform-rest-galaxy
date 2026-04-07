variable "group_id" {
  type        = string
  description = "The object ID of the group to add the member to."
}

variable "member_id" {
  type        = string
  description = "The object ID of the directory object (user, group, service principal) to add as a member."
}
