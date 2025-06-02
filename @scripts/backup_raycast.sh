#!/bin/bash

# Raycast Configuration Backup Script
# Backs up essential Raycast files to dotfiles, excluding cache and temp files

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Directories
RAYCAST_SOURCE="$HOME/Library/Application Support/com.raycast.macos"
DOTFILES_DIR="$HOME/dotfiles"
RAYCAST_BACKUP="$DOTFILES_DIR/raycast"

echo -e "${BLUE}🚀 Raycast Configuration Backup${NC}"
echo "=================================="

# Check if Raycast directory exists
if [[ ! -d "$RAYCAST_SOURCE" ]]; then
    echo -e "${RED}❌ Raycast directory not found at: $RAYCAST_SOURCE${NC}"
    echo "   Make sure Raycast is installed and has been run at least once."
    exit 1
fi

# Check if dotfiles directory exists
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo -e "${RED}❌ Dotfiles directory not found at: $DOTFILES_DIR${NC}"
    echo "   Please create your dotfiles directory first."
    exit 1
fi

# Create backup directory
echo -e "${YELLOW}📁 Creating backup directory...${NC}"
mkdir -p "$RAYCAST_BACKUP"

# Backup with selective exclusions
echo -e "${YELLOW}📋 Backing up Raycast configuration...${NC}"

rsync -av \
    --exclude='cache/' \
    --exclude='logs/' \
    --exclude='tmp/' \
    --exclude='*.log' \
    --exclude='node_modules/' \
    --exclude='extensions/*/node_modules/' \
    --exclude='extensions/*/.git/' \
    --exclude='extensions/*/dist/' \
    --exclude='extensions/*/.cache/' \
    --exclude='quicklink-cache.json' \
    --exclude='raycast.db-*' \
    --exclude='*.sqlite-*' \
    "$RAYCAST_SOURCE/" \
    "$RAYCAST_BACKUP/"

# Show what was backed up
echo -e "\n${GREEN}✅ Backup completed!${NC}"
echo -e "${BLUE}📊 Backup Summary:${NC}"

# Count files and show sizes
SOURCE_SIZE=$(du -sh "$RAYCAST_SOURCE" 2>/dev/null | cut -f1)
BACKUP_SIZE=$(du -sh "$RAYCAST_BACKUP" 2>/dev/null | cut -f1)
FILE_COUNT=$(find "$RAYCAST_BACKUP" -type f | wc -l | tr -d ' ')

echo "   Original size: $SOURCE_SIZE"
echo "   Backup size:   $BACKUP_SIZE"
echo "   Files backed up: $FILE_COUNT"

# Show important files that were backed up
echo -e "\n${BLUE}📝 Key files backed up:${NC}"
if [[ -f "$RAYCAST_BACKUP/preferences.json" ]]; then
    echo "   ✓ preferences.json (main settings)"
fi
if [[ -f "$RAYCAST_BACKUP/raycast.db" ]]; then
    echo "   ✓ raycast.db (database)"
fi
if [[ -d "$RAYCAST_BACKUP/extensions" ]]; then
    EXT_COUNT=$(find "$RAYCAST_BACKUP/extensions" -maxdepth 1 -type d | wc -l | tr -d ' ')
    echo "   ✓ $((EXT_COUNT - 1)) extensions"
fi

# List excluded items that save space
echo -e "\n${YELLOW}🗑️  Excluded (saves space):${NC}"
echo "   • Cache files and directories"
echo "   • Log files"
echo "   • Temporary files"
echo "   • Node modules (will reinstall)"
echo "   • Git repositories in extensions"
echo "   • SQLite temp files"

echo -e "\n${GREEN}🎉 Ready for dotfiles!${NC}"
echo "   Your Raycast config is now backed up to: $RAYCAST_BACKUP"
echo "   You can now commit this to your dotfiles repository."

# Optional: Show git status if in a git repo
if [[ -d "$DOTFILES_DIR/.git" ]]; then
    echo -e "\n${BLUE}📝 Git status:${NC}"
    cd "$DOTFILES_DIR"
    git status --porcelain raycast/ 2>/dev/null || echo "   No git changes detected"
fi 