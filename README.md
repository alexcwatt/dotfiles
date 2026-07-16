# .files

These are my dotfiles.

## Brewfiles

Homebrew packages are split by machine type:

- `dotfiles/Brewfile` — shared/global dependencies for every Mac.
- `dotfiles/Brewfile.personal` — personal-machine-only dependencies.
- `dotfiles/Brewfile.work` — work-machine-only dependencies.

`install/mac.sh` always applies the global Brewfile. It applies the work Brewfile when `/opt/dev` exists, otherwise it applies the personal Brewfile. Override detection with `DOTFILES_BREW_PROFILE=work` or `DOTFILES_BREW_PROFILE=personal`.
