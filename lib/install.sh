#!/usr/bin/env bash
# manage_package: Installs a package using the available package manager if not already present.
# Usage: manage_package <package_name>
# Only manages one package per call.

manage_package() {
    local pkg="$1"
    if [ -z "$pkg" ]; then
        echo "[manage_package] Error: No package name provided." >&2
        return 1
    fi

    # Check if the command is already available
    if command -v "$pkg" >/dev/null 2>&1; then
        echo "[manage_package] '$pkg' is already installed. Skipping."
        return 0
    fi

    echo "[manage_package] Installing '$pkg'..."

    # Try apt-get (Debian/Ubuntu)
    if command -v apt-get >/dev/null 2>&1; then
        sudo apt-get update && sudo apt-get install -y "$pkg"
        return $?
    fi

    # Try dnf (Fedora/RHEL/CentOS)
    if command -v dnf >/dev/null 2>&1; then
        sudo dnf install -y "$pkg"
        return $?
    fi

    # Try yum (older Fedora/RHEL/CentOS)
    if command -v yum >/dev/null 2>&1; then
        sudo yum install -y "$pkg"
        return $?
    fi

    # Try pacman (Arch)
    if command -v pacman >/dev/null 2>&1; then
        sudo pacman -Sy --noconfirm "$pkg"
        return $?
    fi

    # Try zypper (openSUSE)
    if command -v zypper >/dev/null 2>&1; then
        sudo zypper install -y "$pkg"
        return $?
    fi

    # Try apk (Alpine)
    if command -v apk >/dev/null 2>&1; then
        sudo apk add "$pkg"
        return $?
    fi

    # Try brew (macOS)
    if command -v brew >/dev/null 2>&1; then
        brew install "$pkg"
        return $?
    fi

    echo "[manage_package] Error: No supported package manager found. Cannot install '$pkg'." >&2
    return 2
}
