#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
    current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
    cd "${current_dir}" &&
    source "$HOME/set-me-up/dotfiles/utilities/utilities.sh"

declare -r RBENV_DIRECTORY="$HOME/.rbenv"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

install_rbenv_plugin() {

    # **env-latest
    # This **env(pyenv, rbenv, nodenv, goenv, phpenv, luaenv) plugin replaces
    # the version specified in the argument with the latest version.
    # see: https://github.com/momo-lab/xxenv-latest

    git clone https://github.com/momo-lab/xxenv-latest.git "$(rbenv root)"/plugins/xxenv-latest

}

# install_latest_stable_ruby() {

#     # Install the latest stable version of Ruby
#     # (this will also set it as the default).

#     # Determine which version is the LTS version of ruby
#     # see: https://stackoverflow.com/a/30191850/5290011

#     # Determine the current version of Ruby installed
#     # see: https://stackoverflow.com/a/51285042/5290011

#     local latest_version
#     local current_version

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     # Check if `rbenv` is installed

#     if ! cmd_exists "rbenv"; then
#         return 1
#     fi

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     latest_version="$(
#         rbenv install -l | \
#         grep -v - | \
#         tail -1 | \
#         tr -d '[:space:]'
#     )"

#     current_version="$(
#         ruby -e "puts RUBY_VERSION"
#     )"

#     # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

#     if [[ ! -d "$RBENV_DIRECTORY/versions/$latest_version" ]] && [[ "$current_version" != "$latest_version" ]]; then
#         rbenv install "$latest_version" \
#                 && rbenv global "$latest_version"
#     fi

# }

install_latest_stable_ruby() {

    # Install the latest stable version of Ruby
    # (this will also set it as the default).

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check if `rbenv` is installed

    if ! cmd_exists "rbenv"; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # Check that **env-latest is installed
    if -d "$(rbenv root)"/plugins/xxenv-latest; then
        return 1
    fi

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    rbenv latest install

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

    brew_bundle_install -f "brewfile"

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    install_rbenv_plugin

    install_latest_stable_ruby

}

main
