#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # macOS only
    if ! is_macos; then
        warn "copilot-cli is only supported on macOS"
        return 0
    fi

    if ! cmd_exists "github-copilot-cli" && ! cmd_exists "copilot"; then
        brew_bundle_install -f "brewfile"
    fi

}

main
