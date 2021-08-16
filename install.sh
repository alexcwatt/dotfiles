#!/bin/bash

[ ! -d ~/.oh-my-zsh ] && sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

if [ "$SPIN" ]; then
  DOTFILES_DIR=~/dotfiles
else
  DOTFILES_DIR=~/repos-personal/dotfiles
fi

if [ -d $DOTFILES_DIR ] && [ ! -L $DOTFILES_DIR ]; then
  for file in "$DOTFILES_DIR"/dotfiles/*; do
    base="$(basename "$file")"
    if [ "$base" == "Brewfile" ]; then f="$base"; else f=".$base"; fi
    echo "Installing $f..."
    target=~/"$f"
    [ -f "$target" ] && mv "$target" "$target.bak"
    ln -s "$file"  ~/"$f"
  done
else
  echo "Could not find dotfiles directory: $DOTFILES_DIR"
fi

if [ "$SPIN" ]; then
  ./script/spin.sh
else
  ./script/mac.sh
fi
