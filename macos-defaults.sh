#!/usr/bin/env bash
# Scriptable subset of your post-install settings list.
# Anything without a stable `defaults` key across macOS versions is left out
# on purpose (guessing wrong here silently breaks things) — see bootstrap.sh
# output for the manual-step list.
set -euo pipefail

echo "  - Trackpad tracking speed -> max"
defaults write NSGlobalDomain com.apple.trackpad.scaling -float 3.0
defaults -currentHost write NSGlobalDomain com.apple.trackpad.scaling -float 3.0

echo "  - Trackpad tap to click -> on"
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1

echo "  - Dock auto-hide -> on"
defaults write com.apple.dock autohide -bool true

echo "  - Menu bar auto-hide -> always"
defaults write NSGlobalDomain _HIHideMenuBar -bool true

# Restart the affected system processes so changes apply without a full logout
killall Dock 2>/dev/null || true
killall SystemUIServer 2>/dev/null || true

echo "  Applied. Trackpad changes may need a re-login to visually reflect in System Settings."
