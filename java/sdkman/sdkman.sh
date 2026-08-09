#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import base
smu::import java

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_sdkman() {

    # Install `sdkman` and source the necessary shell scripts.

    curl -s "https://get.sdkman.io" | bash &&
        [[ -d "$HOME"/.sdkman ]] && source "$HOME/.sdkman/bin/sdkman-init.sh"

}

update_sdkman() {

    sdk selfupdate force

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if ! is_sdkman_installed; then
        install_sdkman
    else
        update_sdkman
    fi

    sdk_install "java"

}

main
