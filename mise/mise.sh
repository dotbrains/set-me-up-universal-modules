#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_mise_arch() {
    # Install mise on Arch Linux using pacman
    # See: https://mise.jdx.dev/installing-mise.html#arch-linux

    action "Installing mise on Arch Linux"

    pacman -Q mise &>/dev/null && {
        success "mise is already installed"
        exit 0
    }

    sudo pacman -S --noconfirm mise
    success "mise installed successfully"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install mise based on the operating system

    if is_arch_linux; then
        install_mise_arch
        exit 0
    fi

    # Use Homebrew for macOS, Linux (non-Arch), and BSD
    brew_bundle_install -f "brewfile"
}

main
