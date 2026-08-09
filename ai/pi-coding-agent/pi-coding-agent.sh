#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import base
smu::import system

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    if ! cmd_exists "pi"; then

        # Ensure npm is available
        if ! cmd_exists "npm"; then
            error "npm is required to install pi-coding-agent"
            return 1
        fi

        npm install -g @mariozechner/pi-coding-agent
    fi

}

main
