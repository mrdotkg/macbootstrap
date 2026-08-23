# Early 2015 MBP running OCLP macOS Sequoia, Post-Install Bootstrap

## Usage
```bash
chmod +x *.sh
./bootstrap.sh          # Homebrew, dotfiles, scriptable system defaults
./app-store.sh          # uBlock Origin Lite, PiPifier, Hush Nag Blocker (needs App Store sign-in)
./git-setup.sh           # git identity + GitHub SSH key
```
All three are safe to re-run any time — brew bundle is idempotent, dotfile
links back up anything pre-existing instead of clobbering it, git-setup.sh
skips key generation if one already exists.

## What's in here
- `bootstrap.sh` — Xcode CLT, Homebrew, `brew bundle`, dotfile symlinks, TPM
  clone, fzf shell integration, scriptable macOS defaults
- `Brewfile` — every CLI tool + cask, `mas` for the App Store apps
- `app-store.sh` — installs uBlock Origin Lite (id 6745342698), PiPifier —
  Mac version (id 1160374471), Hush Nag Blocker (id 1544743900) via `mas`
- `git-setup.sh` — sets `user.name`/`user.email`, generates an ed25519 key at
  `~/.ssh/id_ed25519_github`, wires it into ssh-agent + Keychain, copies the
  public key to your clipboard for GitHub
- `dotfiles/` — kitty.conf, tmux.conf, zshrc, starship.toml, nvim-init.lua

## Before first run
- Edit `dotfiles/kitty.conf` and `dotfiles/zshrc` — replace `USER@HOST` with
  your actual PC/WSL SSH target.
- Overwrite `dotfiles/starship.toml`, `dotfiles/tmux.conf`, and
  `dotfiles/nvim-init.lua` with your existing WSL versions if you want all
  three machines to feel identical — what's here is a working starting
  point, not a replacement for your tuned configs.
- `nvim-init.lua` uses Neovim 0.12's built-in `vim.pack` (no lazy.nvim). Update
  plugins with `:lua vim.pack.update()` from inside nvim.

## What's NOT automated, and why
- Accessibility text size / menu bar size, Display "More Space", Notes
  default text size — no stable scripting hook across macOS versions, set
  these by hand once.
- App Store installs need an interactive sign-in `mas` can't do on its own —
  that's why they're a separate script instead of folded into `brew bundle`.
- Safari extensions still need manually enabling after install — App Store
  installs the app, not the toggle in Safari's settings.

## Verifying / updating later
```bash
brew bundle check --file=./Brewfile
brew bundle dump --force --file=./Brewfile.snapshot
```
