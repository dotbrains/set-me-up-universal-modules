#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/import.sh"

readonly SMU_PATH="$HOME/set-me-up"

# Get the absolute path of the dotfiles directory.
# This is only for aesthetic reasons to have an absolute symlink path instead of a relative one
# <path-to-smu>/dotfiles/somedotfile vs <path-to-smu>/dotfiles/base/../somedotfile
readonly dotfiles="${SMU_PATH}/dotfiles"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

symlink() {

    # Update and/or install dotfiles. These dotfiles are stored in the dotfiles directory.
    # rcup is used to install files from the tag-specific dotfiles directory.
    # rcup is part of rcm, a management suite for dotfiles.
    # Check https://github.com/thoughtbot/rcm for more info.

    export RCRC="$dotfiles/rcrc" &&
        rcup -v -f -d "${dotfiles}"

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Install Homebrew.

    bash "$dotfiles/modules/universal/homebrew/homebrew.sh"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # We must now symlink our dotfiles prior to executing any other function.
    # This is required because any further action will require our dotfiles
    # to be present in our $HOME directory.
    symlink

}

main
