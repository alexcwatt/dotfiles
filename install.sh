#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

backup_target() {
  local target="$1"

  if [[ -e "$target" || -L "$target" ]]; then
    local backup="$target.bak"
    if [[ -e "$backup" || -L "$backup" ]]; then
      local suffix
      suffix="$(date +%Y%m%d%H%M%S)"
      backup="$target.bak.$suffix"
      local i=1
      while [[ -e "$backup" || -L "$backup" ]]; do
        backup="$target.bak.$suffix.$i"
        ((i++))
      done
    fi
    echo "Backing up $target to $backup"
    mv "$target" "$backup"
  fi
}

install_symlink() {
  local source="$1"
  local target="$2"

  if [[ -L "$target" && "$(readlink "$target")" == "$source" ]]; then
    echo "Already installed $target"
    return
  fi

  backup_target "$target"
  ln -s "$source" "$target"
}

install_file() {
  local source="$1"
  local target="$2"

  mkdir -p "$(dirname "$target")"

  if [[ -f "$target" ]] && cmp -s "$source" "$target"; then
    echo "Already installed $target"
    return
  fi

  backup_target "$target"
  cp "$source" "$target"
}

install_gitconfig() {
  local source="$1"
  local target="$2"

  if [[ -f "$target" ]] && git config --file "$target" --get-all include.path 2>/dev/null | grep -Fx -- "$source" >/dev/null; then
    echo "Already installed $target"
    return
  fi

  backup_target "$target"
  {
    echo "# Machine-local git config; tools may write here."
    echo "[include]"
    printf "\tpath = %s\n" "$source"
  } > "$target"
}

if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
  if [[ "${DOTFILES_SKIP_OH_MY_ZSH:-0}" == "1" ]]; then
    echo "Skipping Oh My Zsh install (DOTFILES_SKIP_OH_MY_ZSH=1)"
  else
    RUNZSH=no CHSH=no KEEP_ZSHRC=yes sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
fi

install_file "$DOTFILES_DIR/.vscode.settings.json" "$HOME/Library/Application Support/Code/User/settings.json"

if [[ -d "$DOTFILES_DIR/dotfiles" ]]; then
  for file in "$DOTFILES_DIR"/dotfiles/*; do
    base="$(basename "$file")"
    if [[ "$base" == "gitconfig" ]]; then
      target="$HOME/.gitconfig"
      echo "Installing $target..."
      install_gitconfig "$file" "$target"
      continue
    elif [[ "$base" == Brewfile* ]]; then
      target="$HOME/$base"
    else
      target="$HOME/.$base"
    fi

    echo "Installing $target..."
    install_symlink "$file" "$target"
  done
else
  echo "Could not find dotfiles directory: $DOTFILES_DIR/dotfiles" >&2
  exit 1
fi

"$DOTFILES_DIR/install/mac.sh"
