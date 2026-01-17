#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"
LOCAL_FISH_CONFIG_FILE="${HOME}/.fish.local"

declare -r MISE_CONFIG_DIR="${HOME}/.config/mise"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_mise_plugin() {

    # Install mise plugin for Node.js if not already installed
    if ! mise plugin list | grep -q "^node"; then
        mise plugin install node
    fi

}

add_mise_configs() {

    # bash

    declare -r BASH_CONFIGS="
# Mise - Node.js version management
export MISE_DATA_DIR=\"$HOME/.local/share/mise\"
eval \"\$(mise activate bash)\""

    if [[ ! -e "$LOCAL_BASH_CONFIG_FILE" ]] || ! grep -q "$(tr <<<\"$BASH_CONFIGS\" '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$BASH_CONFIGS" >>"$LOCAL_BASH_CONFIG_FILE" &&
            . "$LOCAL_BASH_CONFIG_FILE"
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # fish

    declare -r FISH_CONFIGS="
# Mise - Node.js version management
set -gx MISE_DATA_DIR \$HOME/.local/share/mise
mise activate fish | source"

    if [[ ! -e "$LOCAL_FISH_CONFIG_FILE" ]] || ! grep -q "$(tr <<<\"$FISH_CONFIGS\" '\n' '\01')" < <(less "$LOCAL_FISH_CONFIG_FILE" | tr '\n' '\01'); then
        printf '%s\n' "$FISH_CONFIGS" >>"$LOCAL_FISH_CONFIG_FILE"
    fi

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    # Check if mise is installed
    if ! cmd_exists "mise"; then
        printf "mise is not installed. Please install it first.\n"
        return 1
    fi

    install_mise_plugin

    add_mise_configs

}

main
