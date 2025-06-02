#!/bin/bash
set -e

xcode-select --install 2>/dev/null || true
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
eval "$(/opt/homebrew/bin/brew shellenv)" 2>/dev/null || eval "$(/usr/local/bin/brew shellenv)"
brew install ansible
git clone https://github.com/eddydavies/dotfiles.git ~/dotfiles
cd ~/dotfiles
ansible-playbook mac_setup.yml 