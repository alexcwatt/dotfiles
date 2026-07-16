# .files

These are my dotfiles.

## Brewfiles

Homebrew packages are split by machine type:

- `dotfiles/Brewfile` — shared/global dependencies for every Mac.
- `dotfiles/Brewfile.personal` — personal-machine-only dependencies.
- `dotfiles/Brewfile.work` — work-machine-only dependencies.

`install/mac.sh` always applies the global Brewfile. It applies the work Brewfile when `/opt/dev` exists, otherwise it applies the personal Brewfile. Override detection with `DOTFILES_BREW_PROFILE=work` or `DOTFILES_BREW_PROFILE=personal`.

For smoke tests or partial installs, set `DOTFILES_SKIP_OH_MY_ZSH=1` to skip Oh My Zsh installation, `DOTFILES_SKIP_MACOS_DEFAULTS=1` to skip macOS `defaults`/`nvram` changes, and `DOTFILES_SKIP_BREW=1` to skip `brew bundle`.

## Git config

`~/.gitconfig` is intentionally installed as a regular, mutable loader file instead of a symlink. It includes the tracked `dotfiles/gitconfig`, but leaves room for tools that run `git config --global ...` to write machine-local settings without dirtying this repo.
