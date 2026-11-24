#!/usr/bin/env bash
# Check that VANTA is installed and the current repository is indexed.
set -euo pipefail

if ! command -v vanta >/dev/null 2>&1; then
  echo "vanta is not on PATH. Install it from https://vanta.aethlon.xyz/docs" >&2
  exit 1
fi

vanta --version
vanta doctor
