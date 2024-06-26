#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"
LOCAL_FISH_CONFIG_FILE="${HOME}/.fish.local"

declare -r JENV_DIRECTORY="$HOME/.jenv"
declare -r JENV_GIT_REPO_URL="https://github.com/gcuisinier/jenv.git"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If needed, add the necessary configs in the
# local shell configuration files.
add_jenv_configs() {

    # bash

    declare -r BASH_CONFIGS="
# JEnv - Manage your Java environment.
export PATH=\"$JENV_DIRECTORY/bin:\$PATH\"
eval \"\$(jenv  init -)\""

    if [[ ! -e "$LOCAL_BASH_CONFIG_FILE" ]] || ! grep -q "$(tr <<<"$BASH_CONFIGS" '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$BASH_CONFIGS" >>"$LOCAL_BASH_CONFIG_FILE" &&
            . "$LOCAL_BASH_CONFIG_FILE"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# JEnv - Manage your Java environment.
set -gx PATH \$PATH $JENV_DIRECTORY/bin"

    if [[ ! -e "$LOCAL_FISH_CONFIG_FILE" ]] || ! grep -q "$(tr <<<"$FISH_CONFIGS" '\n' '\01')" < <(less "$LOCAL_FISH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$FISH_CONFIGS" >>"$LOCAL_FISH_CONFIG_FILE"
    fi

}

install_jenv() {

    # Install `jenv` and add the necessary
    # configs in the local shell config files.

    git clone --quiet "$JENV_GIT_REPO_URL" "$JENV_DIRECTORY" &&
        add_jenv_configs

}

update_jenv() {

    git -C "$JENV_DIRECTORY" fetch --quiet origin

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    ask_for_sudo

    if [[ ! -d "$JENV_DIRECTORY" ]]; then
        install_jenv
    else
        update_jenv
    fi

}

main
