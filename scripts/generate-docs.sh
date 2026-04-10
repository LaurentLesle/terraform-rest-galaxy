#!/usr/bin/env bash
# generate-docs.sh — Generate docs/yaml-reference.md from Terraform variable definitions.
#
# Usage:
#   ./scripts/generate-docs.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

python3 "${REPO_ROOT}/scripts/generate-docs.py"
