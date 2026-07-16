#!/bin/bash

# Disable the sound effects on boot
sudo nvram SystemAudioVolume=" "

# Finder: show all filename extensions
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

# Finder: show path bar
defaults write com.apple.finder ShowPathbar -bool true

# Avoid creating .DS_Store files on network or USB volumes
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# Create Screenshots directory and configure screenshot location
mkdir -p ~/Documents/Screenshots
defaults write com.apple.screencapture location ~/Documents/Screenshots

if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /usr/local/bin/brew ]]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

run_brew_bundle() {
  local brewfile="$1"

  if [[ -f "$brewfile" ]]; then
    echo "Installing Homebrew bundle: $brewfile"
    brew bundle --file="$brewfile"
  fi
}

run_brew_bundle "$HOME/Brewfile"

brew_profile="${DOTFILES_BREW_PROFILE:-}"
if [[ -z "$brew_profile" ]]; then
  if [[ -d /opt/dev ]]; then
    brew_profile="work"
  else
    brew_profile="personal"
  fi
fi

case "$brew_profile" in
  work)
    echo "Using work Brewfile; check Kepler before adding any work packages"
    run_brew_bundle "$HOME/Brewfile.work"
    ;;
  personal)
    run_brew_bundle "$HOME/Brewfile.personal"
    ;;
  *)
    echo "Unknown DOTFILES_BREW_PROFILE: $brew_profile (expected 'personal' or 'work')" >&2
    exit 1
    ;;
esac
