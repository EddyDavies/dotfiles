#!/bin/bash

DOTFILES_DIR=$HOME/dotfiles

# Brew
brew bundle dump --file=$DOTFILES_DIR/configs/Brewfile --describe --force

# Zsh
cp ~/.zshrc $DOTFILES_DIR/configs/zshrc
# Strip secrets/tokens from the stored zshrc
sed -i '' '/CLAUDE_CODE_OAUTH_TOKEN/d' $DOTFILES_DIR/configs/zshrc
sed -i '' '/sk-ant-/d' $DOTFILES_DIR/configs/zshrc

# Fail loud: abort if any known secret shape survived into the committed zshrc.
# (Real secrets belong in ~/.secrets, which is git-ignored and sourced by zshrc.)
SECRET_PATTERNS='sk-ant-|sk-[A-Za-z0-9]|ghp_|github_pat_|gho_|AKIA[0-9A-Z]{16}|xox[baprs]-|glpat-|AIza[0-9A-Za-z_-]{20}|-----BEGIN [A-Z ]*PRIVATE KEY-----'
if grep -E -n "$SECRET_PATTERNS" "$DOTFILES_DIR/configs/zshrc" >/dev/null 2>&1; then
  echo "❌ Possible secret detected in ~/.zshrc — aborting sync." >&2
  grep -E -n "$SECRET_PATTERNS" "$DOTFILES_DIR/configs/zshrc" | sed 's/=.*/= <redacted>/' >&2
  echo "   Move it into ~/.secrets (git-ignored) and re-run." >&2
  git -C "$DOTFILES_DIR" checkout -- configs/zshrc 2>/dev/null || true
  exit 1
fi

cp ~/.config/starship.toml $DOTFILES_DIR/configs/starship.toml

# Keyboard shortcuts
defaults export com.apple.symbolichotkeys $DOTFILES_DIR/configs/symbolichotkeys.plist

# App Shortcuts (global menu rebinds — System Settings > Keyboard > App Shortcuts)
defaults read -g NSUserKeyEquivalents > $DOTFILES_DIR/configs/nsuserkeyequivalents.txt 2>/dev/null || true

# Karabiner-Elements
[ -f ~/.config/karabiner/karabiner.json ] && \
  cp ~/.config/karabiner/karabiner.json $DOTFILES_DIR/configs/karabiner.json

# Git config
cp ~/.gitconfig $DOTFILES_DIR/configs/gitconfig

# VSCode
mkdir -p $DOTFILES_DIR/configs/vscode-settings
cp -r ~/Library/Application\ Support/Code/User/* $DOTFILES_DIR/configs/vscode-settings/

echo "✅ Dotfiles synced!"
