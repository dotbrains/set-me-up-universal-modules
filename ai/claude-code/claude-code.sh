#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_claude_code_linux() {
    # Install Claude Code on Linux via npm

    if ! cmd_exists "claude"; then
        npm install -g @anthropic-ai/claude-code
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    if ! cmd_exists "claude"; then

        # Use Homebrew cask on macOS, npm on Linux
        if is_macos; then
            brew_bundle_install -f "brewfile"
        else
            install_claude_code_linux
        fi

    fi

}

main