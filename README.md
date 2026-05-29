# 'set-me-up' Universal Modules

[![License: PolyForm Shield 1.0.0](https://img.shields.io/badge/License-PolyForm%20Shield%201.0.0-blue.svg)](https://polyformproject.org/licenses/shield/1.0.0/)

This repository is designed to be used as a submodule to the [`set-me-up` blueprint](https://github.com/dotbrains/set-me-up-blueprint) repository. It contains modules that work on any supported OS — primarily polyglot version managers and language-specific tooling.

## Structure

Modules are organized by language or tool family. Most language families offer multiple version-manager choices side-by-side (e.g. `node/{mise,n,nodenv,nvm,npm}`) so a blueprint can pick whichever fits the user's workflow:

```
universal/
├── ai/               # claude-code, codex, copilot-cli, docker-sandboxes,
│                     #   gemini-cli, herdr, opencode, pi-coding-agent, superset
├── base/             # Bootstraps the smu environment (rcm, dotfile sync, etc.)
├── flox/             # Flox declarative dev environments (cross-OS)
├── homebrew/         # Homebrew itself (cross-OS)
├── mise/             # Polyglot version manager (entry point)
├── go/               # goenv, mise
├── java/             # jenv, mise, sdkman
├── neovim/           # lazyvim, nvchad presets
├── node/             # mise, n, nodenv, npm, nvm
├── nushell/          # Nushell shell
├── php/              # composer, mise, phpenv
├── python/           # mise, pip
├── ruby/             # mise, rbenv
└── rust/             # cargo, mise
```

A module name passed to `smu -m` is the path relative to the `universal/` bucket — e.g. `node/n` runs `node/n/n.sh`, and `python/pip` runs `python/pip/pip.sh`.

## Module kinds

Each module directory contains one of:

- **`<name>.sh`** — most common. Runs custom install logic (curl-piped installers, GitHub-cloned version managers, post-install configuration). Many ship a sibling `brewfile` or `packages` file for shared dependencies (e.g. `node/n/brewfile` declares `n` itself, while `n.sh` configures the prefix).
- **`brewfile`** — a few modules are pure brewfiles that the install can be expressed declaratively (e.g. `mise/brewfile`).
- **`packages`** — used when an install is fully expressible via the Debian DSL (rare here; see `node/npm/packages` for an npm-on-Debian variant).

The `smu` installer resolves a module by name and runs whichever artifact it finds. See the [installer README](https://github.com/dotbrains/set-me-up-installer#discovering-modules) for the full module-resolution rules and the `-p` / `-i` / `-l` flags.

## Cross-platform handling

Unlike the OS-specific module trees, universal modules **don't refuse to run** on the wrong host — they detect the OS internally and adapt. For example, `homebrew/homebrew.sh` calls `apt_install_from_file packages` only when `is_debian`, runs Arch-specific `pacman` setup only when `is_arch_linux`, and otherwise falls through to the standard installer. This lets a single module name (`homebrew`) work across macOS, Debian/Ubuntu, and Arch without per-OS forks.

When authoring a new universal module, prefer this branching style (`if is_debian; then …; elif is_macos; then …; fi`) over a hard `is_macos` guard.

## Auditing and uninstalling

The `smu` installer ships read-only auditing (`smu --status`) and reversal (`smu --uninstall`) for every module:

```bash
smu --status                                 # what's currently installed
smu -u -m node/n                             # uninstall (prompts [y/N])
smu -iu                                      # interactive uninstall via fzf
```

For `brewfile` and `packages` modules, detection and uninstall are automatic via `brew bundle check` / `cleanup` and `apt_install_from_file` / `apt_remove_from_file`. No per-module work is required.

For `*.sh` modules `smu` only acts when the module ships two opt-in sibling files:

- **`<name>.installed`** — sourced by `smu --status`. Exit 0 means installed; non-zero means missing. Without this file, the module reports `unknown` (smu never guesses).
- **`<name>.uninstall.sh`** — sourced by `smu --uninstall`. Without this file, the module is reported as "cannot auto-uninstall — manual cleanup required" and skipped.

If a `*.sh` module shares its directory with a `brewfile` or `packages` file, `smu --uninstall` runs **both** inverses in order: the per-module `<name>.uninstall.sh` first (custom install side-effects), then the declarative cleanup (shared dependencies). Authors can therefore keep each `<name>.uninstall.sh` focused on what its install script did beyond the declarative file.

> **Note:** at the time of writing, none of the universal `*.sh` modules ship sibling `.installed` / `.uninstall.sh` files. Authoring them is an opt-in, per-module choice; modules without them install as before but report `unknown` under `--status` and are skipped by `--uninstall`. Contributions welcome.

See the [installer README](https://github.com/dotbrains/set-me-up-installer#auditing-whats-installed) for the full status/uninstall reference and authoring examples.

## _Why abstract these modules to an external repository?_

When installing the [_blueprint_ configuration](https://github.com/dotbrains/set-me-up-installer/blob/main/install.sh#L229), we need to be able to obtain our custom modules defined in your blueprint as well as the set of universal modules that _set-me-up_ provides.

## License

This project is licensed under the [PolyForm Shield License 1.0.0](https://polyformproject.org/licenses/shield/1.0.0/) — see [LICENSE](LICENSE) for details.