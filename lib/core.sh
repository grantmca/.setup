#!/usr/bin/env bash

include_profile() {
  local profile="$1"
  local profile_path="$(dirname "${BASH_SOURCE[0]}")/../profiles/${profile}.sh"
  if [ -f "$profile_path" ]; then
    source "$profile_path"
  else
    echo "[include_profile] Profile '$profile' not found at $profile_path" >&2
    return 1
  fi
}
