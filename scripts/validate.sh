#!/usr/bin/env bash

set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"

find . -type f -name '*.sh' -not -path '*/.git/*' -exec bash -n {} +

while IFS= read -r manifest; do
    module_dir="$(dirname "$manifest")"
    while IFS= read -r rel_path; do
        target="$module_dir/$rel_path"
        if [[ "$rel_path" != "." && ! -e "$target" ]]; then
            printf "Missing adapter path: %s -> %s\n" "$manifest" "$rel_path" >&2
            exit 1
        fi
    done < <(awk -F= '/^[[:space:]]*path[[:space:]]*=/ { gsub(/[[:space:]"\047]/, "", $2); print $2 }' "$manifest")
done < <(find . -type f -name 'module.toml' -not -path '*/.git/*')

if command -v nix-instantiate >/dev/null 2>&1; then
    find . -type f -name '*.nix' -not -path '*/.git/*' -exec nix-instantiate --parse {} >/dev/null \;
else
    printf "warning: nix-instantiate not found; skipping Nix parse checks\n" >&2
fi
