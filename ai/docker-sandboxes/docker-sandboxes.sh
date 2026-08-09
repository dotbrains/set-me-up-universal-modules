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

    ask_for_sudo

    # macOS only
    if ! is_macos; then
        warn "docker-sandboxes is only supported on macOS"
        return 0
    fi

    brew_bundle_install -f "brewfile"

}

main
