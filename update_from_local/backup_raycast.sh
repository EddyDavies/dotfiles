#!/bin/bash

# Raycast Backup Script
# Uses Raycast's built-in export + selective rsync backup

set -euo pipefail

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

# Paths
RAYCAST_SRC="$HOME/Library/Application Support/com.raycast.macos"
DOTFILES_DIR="$HOME/dotfiles"
RAYCAST_BACKUP="$DOTFILES_DIR/raycast"
EXPORT_FILE="$RAYCAST_SRC/raycast_export.rayconfig"
EXPORT_JSON="$RAYCAST_BACKUP/raycast_export.json"

echo -e "${BLUE}🚀 Raycast Backup${NC}"

# Create backup directory
mkdir -p "$RAYCAST_BACKUP"

# 1. Export Raycast preferences via built-in export
echo -e "${YELLOW}📤 Exporting Raycast preferences...${NC}"
osascript <<EOF
tell application "Raycast" to activate
tell application "System Events"
    delay 0.2
    keystroke "e" using {shift down, command down}
end tell
EOF

sleep 2  # Wait for export to complete

# 2. Decompress .rayconfig to JSON for git versioning
if [[ -f "$EXPORT_FILE" ]]; then
    echo -e "${YELLOW}📋 Converting export to JSON...${NC}"
    gzip --decompress --keep --stdout --suffix .rayconfig "$EXPORT_FILE" > "$EXPORT_JSON"
    rm "$EXPORT_FILE"  # Clean up the temp export file
else
    echo "⚠️  Export file not found, continuing with rsync only..."
fi

# 3. Rsync the rest with exclusions
echo -e "${YELLOW}📁 Backing up Raycast folder...${NC}"
rsync -av --delete \
    --exclude='cache/' \
    --exclude='logs/' \
    --exclude='tmp/' \
    --exclude='*.log' \
    --exclude='node_modules/' \
    --exclude='NodeJS/' \
    --exclude='dist/' \
    --exclude='com.raycast.api.cache/' \
    --exclude='*/com.raycast.api.cache/' \
    --exclude='journal' \
    --exclude='*/journal' \
    --exclude='extensions/*/node_modules/' \
    --exclude='extensions/*/dist/' \
    --exclude='extensions/*/.git/' \
    --exclude='extensions/*/.cache/' \
    --exclude='extensions/*/com.raycast.api.cache/' \
    --exclude='quicklink-cache.json' \
    --exclude='raycast.db-*' \
    --exclude='*.sqlite-*' \
    --exclude='RaycastWrapped/' \
    --exclude='*.png' \
    --exclude='*.jpg' \
    --exclude='*.jpeg' \
    --exclude='*.gif' \
    --exclude='*.webp' \
    --exclude='*.exe' \
    --exclude='*.bin' \
    --exclude='*.so' \
    --exclude='*.dylib' \
    "$RAYCAST_SRC/" \
    "$RAYCAST_BACKUP/"

# 4. Summary
echo -e "\n${GREEN}✅ Backup completed!${NC}"
backup_size=$(du -sh "$RAYCAST_BACKUP" 2>/dev/null | cut -f1)
file_count=$(find "$RAYCAST_BACKUP" -type f | wc -l | tr -d ' ')

echo "   📊 Backup size: $backup_size"
echo "   📄 Files backed up: $file_count"

# Show key files
[[ -f "$EXPORT_JSON" ]] && echo "   ✓ Exported preferences (JSON)"
[[ -f "$RAYCAST_BACKUP/preferences.json" ]] && echo "   ✓ preferences.json"
[[ -f "$RAYCAST_BACKUP/raycast.db" ]] && echo "   ✓ raycast.db"
[[ -d "$RAYCAST_BACKUP/extensions" ]] && echo "   ✓ Extensions folder"

echo -e "\n${GREEN}🎉 Ready for git commit!${NC}" 