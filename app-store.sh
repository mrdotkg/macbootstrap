#!/usr/bin/env bash
# App Store installs — requires being signed into the App Store app first
# (mas can't authenticate on its own). Run: `open -a "App Store"`, sign in,
# then run this script.
set -euo pipefail

if ! command -v mas >/dev/null 2>&1; then
  echo "mas not found — run 'brew bundle' first (it's in the Brewfile)."
  exit 1
fi

if ! mas account >/dev/null 2>&1; then
  echo "Not signed into the App Store. Opening it now — sign in, then re-run this script."
  open -a "App Store"
  exit 1
fi

# App IDs verified against the current App Store listings (Aug 2026):
mas install 6745342698   # uBlock Origin Lite (Raymond Hill)
mas install 1160374471   # PiPifier (Mac version — native Safari extension)
mas install 1544743900   # Hush Nag Blocker

cat <<'EOF'
Installed. One manual step each, since App Store installs don't self-enable
their Safari extensions:
  Safari > Settings > Extensions -> enable uBlock Origin Lite, PiPifier, Hush
EOF
