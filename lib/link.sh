add_layer() {
  local layer="$1"
  local src_root="${DOTFILES:-$HOME/.dotfiles}"

  # Error and exit if the layer directory does not exist
  if [ ! -d "$src_root/$layer" ]; then
    echo "[ERROR][add_layer ] Layer '$layer' not found in '$src_root'"
    exit 1
  fi

  if [ "${DRY_RUN:-0}" -eq 1 ]; then
    echo "[DRY-RUN][add_layer ] Would stow layer '$layer' from '$src_root' to '$HOME'"
    return 0
  fi

  local stow_output
  stow_output=$(stow --simulate -v -d "$src_root" -t "$HOME" "$layer" 2>&1)

  # Backup files that are in the way (old stow output)
  echo "$stow_output" | grep 'exists but is not a symlink' | while read -r line; do
    local file_path
    file_path=$(echo "$line" | sed -E 's/.*LINK: (.*) exists but is not a symlink.*/\1/')
    if [[ "$file_path" != /* ]]; then
      file_path="$HOME/$file_path"
    fi
    if [ -e "$file_path" ]; then
      local timestamp
      timestamp=$(date +%Y%m%d-%H%M%S)
      local backup_path="${file_path}.${timestamp}.bak"
      echo "[BACKUP][add_layer ] Backing up $file_path to $backup_path"
      cp -a "$file_path" "$backup_path"
    fi
  done

  # Backup files that are in the way (new stow output)
  echo "$stow_output" | grep 'cannot stow' | while read -r line; do
    # Example: * cannot stow .dotfiles/sway/.config/test.txt over existing target .config/test.txt since neither a link nor a directory and --adopt not specified
    local file_path
    file_path=$(echo "$line" | sed -E 's/.*over existing target ([^ ]+) since.*/\1/')
    if [[ "$file_path" != /* ]]; then
      file_path="$HOME/$file_path"
    fi
    if [ -e "$file_path" ]; then
      local timestamp
      timestamp=$(date +%Y%m%d-%H%M%S)
      local backup_path="${file_path}.${timestamp}.bak"
      echo "[BACKUP][add_layer ] Backing up $file_path to $backup_path"
      cp -a "$file_path" "$backup_path"
    fi
  done

  stow -d "$src_root" -t "$HOME" "$layer"
  echo "[INFO][add_layer ] Layer '$layer' added successfully."
}


create_layer_cmd() {
  local layer="$1"
  if [ -z "$layer" ]; then
    echo "Usage: $0 create-layer <layer-name>" >&2
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


