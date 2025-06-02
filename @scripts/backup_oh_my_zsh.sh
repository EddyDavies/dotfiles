#!/bin/bash

# Oh My Zsh Backup Script
# Backs up essential oh-my-zsh files excluding git history and cache

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Paths
OH_MY_ZSH_SRC="$HOME/.oh-my-zsh"
DOTFILES_DIR="$HOME/dotfiles"
OH_MY_ZSH_BACKUP="$DOTFILES_DIR/oh-my-zsh"

echo -e "${BLUE}🚀 Oh My Zsh Backup${NC}"

# Check if oh-my-zsh exists
if [[ ! -d "$OH_MY_ZSH_SRC" ]]; then
    echo "⚠️  Oh My Zsh not found at $OH_MY_ZSH_SRC"
    exit 1
fi

# Create backup directory
mkdir -p "$OH_MY_ZSH_BACKUP"

# Backup with exclusions for git, cache, and development files
echo -e "${YELLOW}📁 Backing up Oh My Zsh...${NC}"
rsync -av --delete \
    --exclude='.git/' \
    --exclude='cache/' \
    --exclude='log/' \
    --exclude='.github/' \
    --exclude='.devcontainer/' \
    --exclude='.gitpod.*' \
    --exclude='.prettierrc' \
    --exclude='.editorconfig' \
    --exclude='.gitignore' \
    --exclude='*.md' \
    --exclude='SECURITY.md' \
    --exclude='LICENSE.txt' \
    --exclude='CODE_OF_CONDUCT.md' \
    --exclude='CONTRIBUTING.md' \
    --exclude='README.md' \
    --exclude='.DS_Store' \
    "$OH_MY_ZSH_SRC/" \
    "$OH_MY_ZSH_BACKUP/"

# Summary
echo -e "\n${GREEN}✅ Backup completed!${NC}"
backup_size=$(du -sh "$OH_MY_ZSH_BACKUP" 2>/dev/null | cut -f1)
file_count=$(find "$OH_MY_ZSH_BACKUP" -type f | wc -l | tr -d ' ')

echo "   📊 Backup size: $backup_size"
echo "   📄 Files backed up: $file_count"

# Show key components
[[ -f "$OH_MY_ZSH_BACKUP/oh-my-zsh.sh" ]] && echo "   ✓ Main oh-my-zsh.sh script"
[[ -d "$OH_MY_ZSH_BACKUP/themes" ]] && echo "   ✓ Themes directory"
[[ -d "$OH_MY_ZSH_BACKUP/plugins" ]] && echo "   ✓ Plugins directory"
[[ -d "$OH_MY_ZSH_BACKUP/lib" ]] && echo "   ✓ Library files"
[[ -d "$OH_MY_ZSH_BACKUP/custom" ]] && echo "   ✓ Custom configurations"

echo -e "\n${GREEN}🎉 Ready for git commit!${NC}" 