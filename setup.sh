#!/usr/bin/env bash
set -e

PROFILE="$1"
DOTFILES="$HOME/.dotfiles"

# Clone dotfiles if missing (placeholder, not active in this test)
#[ -d "$DOTFILES" ] || git clone https://github.com/yourname/dotfiles.git "$DOTFILES"

# Load core functions
for file in "$(dirname "$0")/lib"/*.sh; do
  [ -f "$file" ] && source "$file"
done

# Run profile logic
PROFILE_PATH="$(dirname "$0")/profiles/$PROFILE.sh"
if [ -f "$PROFILE_PATH" ]; then
  source "$PROFILE_PATH"
else
  echo "Profile '$PROFILE' not found at $PROFILE_PATH" >&2
  exit 1
fi
