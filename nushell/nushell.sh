#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_nushell_arch() {
    # Install nushell on Arch Linux using pacman
    # See: https://wiki.archlinux.org/title/Nushell

    action "Installing nushell on Arch Linux"

    if ! pacman -Q nushell &>/dev/null; then
        sudo pacman -S --noconfirm nushell
    fi

    success "nushell is already installed"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install nushell based on the operating system

    if is_arch_linux; then
        install_nushell_arch
        exit 0
    fi

    # Use Homebrew for macOS, Linux (non-Arch), and BSD
    brew_bundle_install -f "brewfile"
}

main
