#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import base
smu::import system
smu::import homebrew

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    brew_bundle_install -f "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if git is installed
    if ! cmd_exists "git"; then
        print_error "Git is required, please install it!\n"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # NvChad

    # Check if ~/.config/nvim exists
    if [ -d "$HOME/.config/nvim" ]; then
        mv "$HOME/.config/nvim" "$HOME/.config/nvchad.backup"
    fi

    git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1

    # Remove the .git folder, so it doesn't interfere with the dotfiles git repo
    rm -rf ~/.config/nvim/.git
}

main
