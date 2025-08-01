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

  local stow_output
  stow_output=$(stow --no -v -d "$src_root" -t "$HOME" "$layer" 2>&1)
  if echo "$stow_output" | grep -qE '^(LINK|SYMLINK):'; then
    stow -d "$src_root" -t "$HOME" "$layer"
    echo "[INFO][add_layer] Layer '$layer' added successfully."
  else
    echo "[INFO][add_layer] Layer '$layer' already exists and is up to date."
  fi

}

# Subcommand: add-layer <layer-name>
add_layer_cmd() {
  local layer="$1"
  if [ -z "$layer" ]; then
    echo "Usage: $0 add-layer <layer-name>" >&2
    exit 1
  fi
  local layer_dir="$DOTFILES/$layer/.config"
  if [ -d "$DOTFILES/$layer" ]; then
    echo "Layer '$layer' already exists at $DOTFILES/$layer" >&2
    exit 1
  fi
  mkdir -p "$layer_dir"
  echo "Created layer: $DOTFILES/$layer with .config/"
}

