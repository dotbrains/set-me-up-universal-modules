#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import base
smu::import system
smu::import homebrew

LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"
LOCAL_FISH_CONFIG_FILE="${HOME}/.fish.local"

declare -r N_DIRECTORY="$HOME/n"

declare -r N_URL="https://git.io/n-install"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If needed, add the necessary configs in the
# local shell configuration files.
add_n_configs() {

    # bash

    declare -r BASH_CONFIGS="
# n - Node version management.
export N_PREFIX=\"\$HOME/n\";
[[ :\$PATH: == *\":\$N_PREFIX/bin:\"* ]] || PATH+=\":\$N_PREFIX/bin\"
"

    if [[ ! -e "$LOCAL_BASH_CONFIG_FILE" ]] || ! grep -q "$(tr <<<"$BASH_CONFIGS" '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$BASH_CONFIGS" >>"$LOCAL_BASH_CONFIG_FILE" &&
            . "$LOCAL_BASH_CONFIG_FILE"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# n - Node version management.
set -xU N_PREFIX \"\$HOME/n\"
set -U fish_user_paths \"\$N_PREFIX/bin\" \$fish_user_paths
"

    if [[ ! -e "$LOCAL_FISH_CONFIG_FILE" ]] || ! grep -q -z "$FISH_CONFIGS" "$LOCAL_BASH_CONFIG_FILE" &>/dev/null; then
        printf '%s\n' "$FISH_CONFIGS" >>"$LOCAL_FISH_CONFIG_FILE"
    fi

}

install_n() {

    # Install `n` and add the necessary
    # configs in the local shell config files.

    curl -sL "$N_URL" | N_PREFIX="$N_DIRECTORY" bash -s -- -q -n && add_n_configs

}

update_n() {

    # Load `n`

    export N_PREFIX="$N_DIRECTORY"
    [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    n-update -y

}

install_latest_stable_node_with_n() {

    # Install the latest stable version of Node
    # (this will also set it as the default).

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `n` is installed

    if ! cmd_exists "n"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Load `n`

    export N_PREFIX="$N_DIRECTORY"
    [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    sudo n lts

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    brew_bundle_install -f "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    if [[ ! -d "$N_DIRECTORY" ]] && ! cmd_exists "n"; then
        install_n
    else
        update_n
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_latest_stable_node_with_n

}

main
