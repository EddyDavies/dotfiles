#!/bin/bash

DOTFILES_DIR=$HOME/dotfiles

# Brew
brew bundle dump --file=$DOTFILES_DIR/configs/Brewfile --describe --force

# Zsh
cp ~/.zshrc $DOTFILES_DIR/configs/zshrc
# Strip secrets/tokens from the stored zshrc
sed -i '' '/CLAUDE_CODE_OAUTH_TOKEN/d' $DOTFILES_DIR/configs/zshrc
sed -i '' '/sk-ant-/d' $DOTFILES_DIR/configs/zshrc
cp ~/.config/starship.toml $DOTFILES_DIR/configs/starship.toml

# Keyboard shortcuts
defaults export com.apple.symbolichotkeys $DOTFILES_DIR/configs/symbolichotkeys.plist

# Git config
cp ~/.gitconfig $DOTFILES_DIR/configs/gitconfig

# VSCode
mkdir -p $DOTFILES_DIR/configs/vscode-settings
cp -r ~/Library/Application\ Support/Code/User/* $DOTFILES_DIR/configs/vscode-settings/

echo "✅ Dotfiles synced!"
