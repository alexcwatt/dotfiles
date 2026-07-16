#!/usr/bin/env bash
set -euo pipefail

configure_macos_defaults() {
  # Disable the sound effects on boot. This can fail on machines where nvram is
  # restricted, so warn instead of aborting the rest of the install.
  sudo nvram SystemAudioVolume=" " || echo "Warning: could not update nvram SystemAudioVolume" >&2

  # Finder: show all filename extensions
  defaults write NSGlobalDomain AppleShowAllExtensions -bool true

  # Finder: show path bar
  defaults write com.apple.finder ShowPathbar -bool true

  # Avoid creating .DS_Store files on network or USB volumes
  defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
  defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

  # Create Screenshots directory and configure screenshot location
  mkdir -p "$HOME/Documents/Screenshots"
  defaults write com.apple.screencapture location "$HOME/Documents/Screenshots"
}

setup_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  if ! command -v brew >/dev/null 2>&1; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  if ! command -v brew >/dev/null 2>&1; then
    if [[ -x /opt/homebrew/bin/brew ]]; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    elif [[ -x /usr/local/bin/brew ]]; then
      eval "$(/usr/local/bin/brew shellenv)"
    fi
  fi

  if ! command -v brew >/dev/null 2>&1; then
    echo "Homebrew was not found after installation" >&2
    exit 1
  fi
}

run_brew_bundle() {
  local brewfile="$1"

  if [[ -f "$brewfile" ]]; then
    echo "Installing Homebrew bundle: $brewfile"
    brew bundle --file="$brewfile"
  fi
}

if [[ "${DOTFILES_SKIP_MACOS_DEFAULTS:-0}" != "1" ]]; then
  configure_macos_defaults
else
  echo "Skipping macOS defaults (DOTFILES_SKIP_MACOS_DEFAULTS=1)"
fi

if [[ "${DOTFILES_SKIP_BREW:-0}" == "1" ]]; then
  echo "Skipping Homebrew bundle install (DOTFILES_SKIP_BREW=1)"
  exit 0
fi

setup_homebrew
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
