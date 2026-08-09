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

install_pip_packages() {

    # Check that pip3 are installed

    if ! cmd_exists "pip3"; then
        print_error "pip3 is not installed"
        exit 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Install pip packages

    pip3 install
    # trash-cli trashes files recording the original path, deletion date, and permissions.
    # It uses the same trashcan used by KDE, GNOME, and XFCE, but you can invoke it from
    # the command line (and scripts).
    # https://github.com/andreafrancia/trash-cli
    trash-cli \
        'trash-cli[completion]'
    # Performance monitoring CLI tool for Apple Silicon
    # see: https://github.com/tlkh/asitop
    asitop
}

main() {

    brew_bundle_install -f "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_pip_packages

}

main
