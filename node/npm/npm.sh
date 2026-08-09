#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import system

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    apt_install_from_file "packages"

}

main
