#!/usr/bin/env bash
# OCLP Sequoia post-install bootstrap — Kumar's MBP thin-client setup
# Idempotent: safe to re-run any time (e.g. after a fresh OCLP reinstall).
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> [1/5] Xcode Command Line Tools"
if ! xcode-select -p >/dev/null 2>&1; then
  xcode-select --install
  echo "    Xcode CLT installer launched — finish that GUI prompt, then re-run this script."
  exit 0
fi

echo "==> [2/5] Homebrew"
if ! command -v brew >/dev/null 2>&1; then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# Make brew available in this script's shell regardless of Apple Silicon/Intel prefix
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

echo "==> [3/5] Brewfile bundle (formulae + casks + taps)"
brew bundle --file="${SCRIPT_DIR}/Brewfile"

echo "==> [4/5] Dotfile symlinks"
DOTFILES_DIR="${SCRIPT_DIR}/dotfiles"
mkdir -p "$HOME/.config/kitty"

link() {
  # $1 = source in dotfiles/, $2 = target path
  if [ -e "$2" ] && [ ! -L "$2" ]; then
    mv "$2" "$2.pre-bootstrap.bak"
    echo "    backed up existing $2 -> $2.pre-bootstrap.bak"
  fi
  ln -sfn "$1" "$2"
  echo "    linked $2"
}

mkdir -p "$HOME/.config/nvim"
link "$DOTFILES_DIR/kitty.conf"   "$HOME/.config/kitty/kitty.conf"
#link "$DOTFILES_DIR/starship.toml" "$HOME/.config/starship.toml"
link "$DOTFILES_DIR/tmux.conf"   "$HOME/.tmux.conf"
link "$DOTFILES_DIR/zshrc"       "$HOME/.zshrc"
link "$DOTFILES_DIR/nvim-init.lua" "$HOME/.config/nvim/init.lua"

# tmux plugin manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  echo "    TPM cloned — inside tmux, press prefix + I to install plugins"
fi

# fzf shell integration (keybindings + fuzzy completion)
if command -v fzf >/dev/null 2>&1; then
  "$(brew --prefix)/opt/fzf/install" --key-bindings --completion --no-update-rc --no-bash --no-fish
fi

echo "==> [5/5] macOS system defaults (scriptable subset)"
bash "${SCRIPT_DIR}/macos-defaults.sh"

cat <<'EOF'

==> Two more steps, run manually (each is interactive / needs sign-in):

  1. App Store apps (uBlock Origin Lite, PiPifier, Hush Nag Blocker):
       ./app-store.sh
     (needs you signed into the App Store app first — the script checks and
     opens it for you if not)

  2. Git identity + GitHub SSH key:
       ./git-setup.sh
     (prompts for name/email, generates an ed25519 key, wires it into
     ssh-agent + macOS Keychain, and copies the public key to your clipboard
     to paste into GitHub)

Remaining MANUAL steps with no reliable scripting hook at all:
  - Accessibility > Display > Text Size -> 16px
  - Accessibility > Menu Bar Size -> Large
  - Displays > Built-in Display > "More Space" (1680x1050)
  - Notes app > Settings > Default Text Size -> one level up
  - After app-store.sh: Safari > Settings > Extensions -> enable each one

  Note: Barrier's upstream project is archived/unmaintained. The cask still
  installs today, but if it ever disappears from homebrew-cask, input-leap
  (an actively maintained fork) is the drop-in replacement — same config format.
EOF
