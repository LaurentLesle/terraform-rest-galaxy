#!/usr/bin/env bash
# Get an Azure access token for local Terraform development by refreshing via Azure CLI.
#
# Usage:
#   source .github/scripts/get-dev-token.sh           # sets TF_VAR_access_token in current shell
#   eval "$(.github/scripts/get-dev-token.sh --export)" # subshell export
#
# Prerequisites: az login must have been run.

set -euo pipefail

if ! command -v az &>/dev/null; then
  echo "Error: Azure CLI (az) is not installed. Run: brew install azure-cli" >&2
  exit 1
fi

if ! az account show &>/dev/null 2>&1; then
  echo "Error: Not logged in to Azure CLI. Run: az login" >&2
  exit 1
fi

ACCESS_TOKEN=$(az account get-access-token \
  --resource https://management.azure.com \
  --query accessToken \
  --output tsv)

export TF_VAR_access_token="$ACCESS_TOKEN"
echo "TF_VAR_access_token set (${ACCESS_TOKEN:0:20}...)" >&2

# When called with --export (subshell), print the export statement
if [[ "${1:-}" == "--export" ]]; then
  echo "export TF_VAR_access_token='${ACCESS_TOKEN}'"
fi
