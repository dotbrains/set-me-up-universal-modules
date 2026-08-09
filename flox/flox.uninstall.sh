#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import base
smu::import system

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

uninstall_flox_arch() {
    # Reverse install_flox_arch: remove the AUR flox-bin package.

    action "Uninstalling Flox on Arch Linux"

    if ! pacman -Q flox-bin &>/dev/null; then
        success "Flox is not installed"
        return 0
    fi

    if cmd_exists "paru"; then
        paru -Rs --noconfirm flox-bin
    elif cmd_exists "yay"; then
        yay -Rs --noconfirm flox-bin
    else
        error "An AUR helper (paru or yay) is required to uninstall Flox on Arch."
        return 1
    fi

    success "Flox uninstalled successfully"
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    if is_arch_linux; then
        uninstall_flox_arch
        return
    fi

    # macOS and Linux (linuxbrew): smu chains `brew bundle cleanup --force`
    # against the sibling brewfile automatically — nothing to do here.
    :
}

main
