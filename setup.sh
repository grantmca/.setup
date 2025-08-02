#!/usr/bin/env bash
set -e

# Source environment variables
ENV_FILE="$(dirname "$0")/env.sh"
[ -f "$ENV_FILE" ] && source "$ENV_FILE"

# Parse arguments
DRY_RUN=0
SUBCOMMAND=""
PROFILE=""

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run|-n)
      DRY_RUN=1
      shift
      ;;
    create-layer)
      SUBCOMMAND="create-layer"
      shift
      ;;
    *)
      if [ -z "$PROFILE" ]; then
        PROFILE="$1"
      fi
      shift
      ;;
  esac
done

# Load core functions (including manage_package)
for file in "$(dirname "$0")/lib"/*.sh; do
  [ -f "$file" ] && source "$file"
done

if [ "$SUBCOMMAND" = "create-layer" ]; then
  create_layer_cmd "$PROFILE"
  exit 0
fi

# Ensure git and stow are installed before anything else
manage_package git
manage_package stow

export DRY_RUN

PROFILE_PATH="$(dirname "$0")/profiles/$PROFILE.sh"
if [ -f "$PROFILE_PATH" ]; then
  source "$PROFILE_PATH"
else
  echo "Profile '$PROFILE' not found at $PROFILE_PATH" >&2
  exit 1
fi
