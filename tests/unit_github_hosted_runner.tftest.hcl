# Unit test — modules/github/hosted_runner
# Tests the sub-module in isolation (plan only).
# Run: terraform test -filter=tests/unit_github_hosted_runner.tftest.hcl

provider "rest" {
  base_url = "https://api.github.com"
  security = {
    http = {
      token = {
        token = "placeholder"
      }
    }
  }
}

run "plan_hosted_runner" {
  command = plan

  module {
    source = "./modules/github/hosted_runner"
  }

  variables {
    organization    = "my-org"
    name            = "linux-4core-vnet"
    image_id        = "ubuntu-24.04"
    image_source    = "github"
    size            = "4-core"
    runner_group_id = 12345
    maximum_runners = 10
  }

  assert {
    condition     = output.name == "linux-4core-vnet"
    error_message = "Name output must echo input."
  }

  assert {
    condition     = output.organization == "my-org"
    error_message = "Organization output must echo input."
  }

  assert {
    condition     = output.size == "4-core"
    error_message = "Size output must echo input."
  }

  assert {
    condition     = output.runner_group_id == 12345
    error_message = "Runner group ID output must echo input."
  }
}
