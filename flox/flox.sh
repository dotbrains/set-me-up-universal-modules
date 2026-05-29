#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_flox_arch() {
    # Install Flox on Arch Linux via the AUR (no official pacman package).
    # See: https://flox.dev/docs/install-flox/

    action "Installing Flox on Arch Linux"

    pacman -Q flox-bin &>/dev/null && {
        success "Flox is already installed"
        exit 0
    }

    if cmd_exists "paru"; then
        paru -S --noconfirm flox-bin
    elif cmd_exists "yay"; then
        yay -S --noconfirm flox-bin
    else
        error "An AUR helper (paru or yay) is required to install Flox on Arch."
        exit 1
    fi

    success "Flox installed successfully"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install Flox based on the operating system

    if is_arch_linux; then
        install_flox_arch
        exit 0
    fi

    # Use Homebrew for macOS and Linux (linuxbrew)
    brew_bundle_install -f "brewfile"
}

main
