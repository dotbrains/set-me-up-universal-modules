#!/bin/bash

# shellcheck source=/dev/null

declare current_dir &&
	current_dir="$(dirname "${BASH_SOURCE[0]}")" &&
	cd "${current_dir}" &&
	source "$HOME/set-me-up/dotfiles/utilities/import.sh"

smu::import base
smu::import system

LOCAL_BASH_CONFIG_FILE="${HOME}/.bash.local"
LOCAL_FISH_CONFIG_FILE="${HOME}/.fish.local"

declare -r NVM_DIRECTORY="$HOME/.nvm"

declare -r NVM_URL="https://raw.githubusercontent.com/nvm-sh/nvm/v0.36.0/install.sh"

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# If needed, add the necessary configs in the
# local shell configuration files.
add_nvm_configs() {

	# bash

	declare -r BASH_CONFIGS="
# nvm - Node version management.
export NVM_DIR=\"$HOME/.nvm\"
[ -s \"\$NVM_DIR/nvm.sh\" ] && \. \"\$NVM_DIR/nvm.sh\"  # This loads nvm
[ -s \"\$NVM_DIR/bash_completion\" ] && \. \"\$NVM_DIR/bash_completion\"  # This loads nvm bash_completion
"

	if [[ ! -e "$LOCAL_BASH_CONFIG_FILE" ]] || ! grep -q "$(tr <<<"$BASH_CONFIGS" '\n' '\01')" < <(less "$LOCAL_BASH_CONFIG_FILE" | tr '\n' '\01'); then
		printf '%s\n' "$BASH_CONFIGS" >>"$LOCAL_BASH_CONFIG_FILE" &&
			. "$LOCAL_BASH_CONFIG_FILE"
	fi

}

install_nvm() {

	# Install `nvm` and add the necessary
	# configs in the local shell config files.

	curl -o- "$NVM_URL" | bash -s -- -q &&
		add_nvm_configs

}

update_nvm() {

	# Load `nvm` from $NVM_DIR

	export NVM_DIR="$NVM_DIRECTORY"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	(
		git -C "$NVM_DIR" fetch --tags origin &&
			git -C "$NVM_DIR" checkout \
				"$(git -C "$NVM_DIR" describe --abbrev=0 --tags --match \"v[0-9]*\" "$(git -C "$NVM_DIR" rev-list --tags --max-count=1)")"
	) &&
		. "$NVM_DIR/nvm.sh" -q

}

install_latest_stable_node_with_nvm() {

	# Install the latest stable version of Node
	# (this will also set it as the default).

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	# Load `nvm` from $NVM_DIR

	export NVM_DIR="$NVM_DIRECTORY"
	[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"                   # This loads nvm
	[ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion" # This loads nvm bash_completion

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	nvm install --lts

}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

main() {

	ask_for_sudo

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	if [[ ! -d "$NVM_DIRECTORY" ]] && ! cmd_exists "nvm"; then
		install_nvm
	else
		update_nvm
	fi

	# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

	install_latest_stable_node_with_nvm

}

main
