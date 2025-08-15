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

/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

if [[ -d /opt/dev ]]; then
  echo "Skipping brew bundle install - check Kepler before installing any packages"
else
  (cd ~ || exit; brew bundle)
fi

# Automatically remove Mos from quarantine
( cd /Applications && xattr -d com.apple.quarantine Mos.app )
