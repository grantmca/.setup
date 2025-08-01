#!/usr/bin/env bash
set -e

# Source environment variables
ENV_FILE="$(dirname "$0")/env.sh"
[ -f "$ENV_FILE" ] && source "$ENV_FILE"
export DOTFILES="${DOTFILES:-$HOME/.dotfiles}"

# Parse arguments
DRY_RUN=0
SUBCOMMAND=""
PROFILE=""
for arg in "$@"; do
  case "$arg" in
    --dry-run|-n)
      DRY_RUN=1
      ;;
    add-layer)
      SUBCOMMAND="add-layer"
      ;;
    *)
      if [ -z "$PROFILE" ]; then
        PROFILE="$arg"
      fi
      ;;
  esac
  shift
done

# Load core functions (including manage_package)
for file in "$(dirname "$0")/lib"/*.sh; do
  [ -f "$file" ] && source "$file"
done

if [ "$SUBCOMMAND" = "add-layer" ]; then
  add_layer_cmd "$PROFILE"
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
