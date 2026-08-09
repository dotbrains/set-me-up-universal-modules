#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import base
smu::import system

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_phpenv() {

    # No need to check if `phpenv` is installed because the installer will
    # automatically check if it's already installed and update it if necessary.
    # see: https://github.com/phpenv/phpenv-installer

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install `phpenv`

    # Check if `curl` is installed
    if ! cmd_exists "curl"; then
        curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-installer | bash

        # Verify that the installation was successful
        curl -L https://raw.githubusercontent.com/phpenv/phpenv-installer/master/bin/phpenv-doctor | bash

        return $?
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_phpenv

}

main
