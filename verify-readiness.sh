#!/usr/bin/env bash
# Deprecated: use stack-check (agentic 5-layer verifier with verdict and remediation).
# This wrapper keeps existing CI/scripts working.

set -euo pipefail
_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" && pwd)"
exec "${_DIR}/stack-check" "$@"
