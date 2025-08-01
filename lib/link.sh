add_layer() {
  local layer="$1"
  local src_root="${DOTFILES:-$HOME/.dotfiles}"

  # Error and exit if the layer directory does not exist
  if [ ! -d "$src_root/$layer" ]; then
    echo "[ERROR][add_layer] Layer '$layer' not found in '$src_root'"
    exit 1
  fi

  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    echo "[DRY-RUN][add_layer] Would stow layer '$layer' from '$src_root' to '$HOME'"
    return 0
  fi
  stow -d "$src_root" -t "$HOME" "$layer"
}

