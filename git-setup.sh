#!/usr/bin/env bash
# Git config + GitHub SSH key — run once per machine.
set -euo pipefail

read -rp "Git user.name: " GIT_NAME
read -rp "Git user.email: " GIT_EMAIL

git config --global user.name  "$GIT_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global init.defaultBranch main
git config --global pull.rebase false

KEY_PATH="$HOME/.ssh/id_ed25519_github"
mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"

if [ ! -f "$KEY_PATH" ]; then
  ssh-keygen -t ed25519 -C "$GIT_EMAIL" -f "$KEY_PATH"
else
  echo "Key already exists at $KEY_PATH — skipping generation."
fi

# Start (or reuse) ssh-agent for this session
eval "$(ssh-agent -s)" >/dev/null

SSH_CONFIG="$HOME/.ssh/config"
touch "$SSH_CONFIG"
chmod 600 "$SSH_CONFIG"
if ! grep -q "^Host github.com$" "$SSH_CONFIG" 2>/dev/null; then
  cat >> "$SSH_CONFIG" <<EOF

Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile $KEY_PATH
EOF
  echo "Added a github.com entry to $SSH_CONFIG"
fi

# Add to the agent, persisting via macOS Keychain so it survives reboots
ssh-add --apple-use-keychain "$KEY_PATH" 2>/dev/null || ssh-add "$KEY_PATH"

pbcopy < "${KEY_PATH}.pub"
echo
echo "Public key copied to your clipboard."
echo "Add it here: https://github.com/settings/ssh/new"
read -rp "Press enter once you've added it on GitHub to test the connection... " _

ssh -T git@github.com || true
