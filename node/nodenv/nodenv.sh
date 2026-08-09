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

install_nodenv() {

    # No need to check if `nodenv` is installed because the installer will
    # automatically check if it's already installed and update it if necessary.
    # see: https://github.com/nodenv/nodenv-installer#nodenv-installer

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install `nodenv`
    # We can install `nodenv` using one of the three methods below.
    # We will use the first method that is available on the user's machine.

    # Check if `curl` is installed
    if ! cmd_exists "curl"; then
        curl -fsSL https://github.com/nodenv/nodenv-installer/raw/HEAD/bin/nodenv-installer | bash

        # Verify that the installation was successful
        curl -fsSL https://github.com/nodenv/nodenv-installer/raw/HEAD/bin/nodenv-doctor | bash

        return $?
    fi

    # Check if `wget` is installed
    if ! cmd_exists "wget"; then
        wget -q https://github.com/nodenv/nodenv-installer/raw/HEAD/bin/nodenv-installer -O- | bash

        # Verify that the installation was successful
        wget -q https://github.com/nodenv/nodenv-installer/raw/HEAD/bin/nodenv-doctor -O- | bash

        return $?
    fi

    # Check if npx is installed
    if ! cmd_exists "npx"; then
        npx @nodenv/nodenv-installer

        # Verify that the installation was successful
        npx -p @nodenv/nodenv-installer nodenv-doctor

        return $?
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    brew_bundle_install -f "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_nodenv

}

main
