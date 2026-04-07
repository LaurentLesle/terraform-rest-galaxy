terraform {
  required_providers {
    rest = {
      source  = "LaurentLesle/rest"
      version = "~> 1.0"
    }
  }
}

provider "rest" {
  base_url = "https://management.azure.com"
  security = {
    http = {
      token = {
        token = "unused"
      }
    }
  }
}

provider "rest" {
  alias    = "graph"
  base_url = "https://graph.microsoft.com"
  security = {
    http = {
      token = {
        token = var.graph_access_token
      }
    }
  }
}

locals {
  graph_token = coalesce(var.graph_access_token, "")
}

module "root" {
  source = "../../../../"

  graph_access_token = local.graph_token

  entraid_groups = {
    complete = {
      display_name          = "tf-test-gm-complete-group"
      mail_enabled          = false
      mail_nickname         = "tf-test-gm-complete-group"
      security_enabled      = true
      description           = "Complete example group for group member test"
      is_assignable_to_role = true
    }
  }

  entraid_users = {
    complete = {
      display_name        = "TF GM Complete User"
      mail_nickname       = "tf-gm-complete-user"
      user_principal_name = var.user_principal_name
      account_enabled     = true
      password_profile = {
        password                           = var.password
        force_change_password_next_sign_in = true
      }
      given_name = "Complete"
      surname    = "TestUser"
      department = "Engineering"
    }
  }

  entraid_group_members = {
    complete = {
      group_id  = "ref:entraid_groups.complete.id"
      member_id = "ref:entraid_users.complete.id"
    }
  }
}
