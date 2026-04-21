#!/usr/bin/env bash
set -euo pipefail

echo "[Info] setup_libero_lerobot.sh has been renamed to lebero_lerobot_environment_creation.sh"
exec bash "$(dirname "$0")/lebero_lerobot_environment_creation.sh" "$@"
