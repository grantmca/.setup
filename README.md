# Dotfiles Setup Framework

This is a portable, idempotent Bash-based system for quickly configuring your development environment from scratch on any machine.

## What is this?
- A set of Bash scripts to automate setup of your dev environment.
- Uses “profiles” to define which tools and configs to install.
- Symlinks dotfiles from a Git-managed directory.
- Installs required packages using your system’s package manager.

## Why use it?
- Works anywhere with Bash, Git, and a package manager.
- Idempotent: safe to rerun, always converges to the correct state.
- Minimal dependencies: just Bash, Git, and Stow (auto-installed if missing).
- Easy to extend and maintain.

## Requirements
- bash
- git
- stow
- A package manager (apt, pacman, brew, etc.)

## Quick Start
1. Clone your dotfiles repo:
   ```sh
   git clone https://github.com/yourname/.dotfiles.git ~/.dotfiles
   ```
2. Run the setup script with a profile:
   ```sh
   cd setup
   ./setup.sh dev
   # or: ./setup.sh work
   ```

Profiles are in `setup/profiles/` (e.g., `dev.sh`, `work.sh`).

## How it works
- Profiles declare which layers (config sets) and packages to apply.
- Layers are folders in `.dotfiles/` that get symlinked into place.
- Rerunning the script updates links and installs missing tools.

## Example profile
```bash
manage_package git
manage_package stow
add_layer zsh
add_layer nvim
```

## Project Structure
```
setup/
  setup.sh
  lib/
  profiles/
.dotfiles/
  zsh/
  nvim/
  ...
```

## License
MIT
