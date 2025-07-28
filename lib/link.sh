add_layer() {
  local layer="$1"
  local src_root="$HOME/.dotfiles"
  stow -d "$src_root" -t "$HOME" "$layer"
}
