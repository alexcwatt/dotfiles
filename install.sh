#!/bin/bash

if [ "$SPIN" ]; then
  DOTFILES_DIR=~/dotfiles

  ./script/spin.sh
else
  DOTFILES_DIR=~/repos-personal/dotfiles
fi

if [ -d $DOTFILES_DIR ] && [ ! -L $DOTFILES_DIR ]; then
  for file in "$DOTFILES_DIR"/dotfiles/*; do
    echo "Installing $file..."
    f=".$(basename "$file")"
    target=~/"$f"
    [ -f "$target" ] && mv "$target" "$target.bak"
    ln -s "$file"  ~/"$f"
  done
else
  echo "Could not find dotfiles directory: $DOTFILES_DIR"
fi

sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
