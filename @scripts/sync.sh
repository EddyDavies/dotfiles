#!/bin/bash

DOTFILES_DIR=$HOME/dotfiles

# Brew
brew bundle dump --file=$DOTFILES_DIR/Brewfile --describe --force

# MAS
mas list > $DOTFILES_DIR/mas_apps.txt

# Zsh
cp ~/.zshrc $DOTFILES_DIR/zshrc
cp -r ~/.oh-my-zsh $DOTFILES_DIR/oh-my-zsh
cp ~/.config/starship.toml $DOTFILES_DIR/.config/starship.toml

# Keyboard shortcuts
defaults export com.apple.symbolichotkeys $DOTFILES_DIR/symbolichotkeys.plist

# Git config
cp ~/.gitconfig $DOTFILES_DIR/gitconfig

# VSCode
mkdir -p $DOTFILES_DIR/vscode-settings
cp -r ~/Library/Application\ Support/Code/User/* $DOTFILES_DIR/vscode-settings/

echo "✅ Dotfiles synced!" 