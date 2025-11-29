#!/bin/bash

APP_LIST="$HOME/dotfiles/all_apps.txt"
BREWFILE="$HOME/dotfiles/Brewfile"

echo "📂 Using app list: $APP_LIST"
echo "📦 Updating Brewfile: $BREWFILE"
touch "$BREWFILE"

while IFS= read -r line; do
  # Remove .app if present
  app_name="${line%.app}"
  search_term=$(echo "$app_name" | tr '[:upper:]' '[:lower:]' | tr -s ' ' '-' | tr -cd '[:alnum:]-')

  # Skip empty lines or system apps
  [[ -z "$app_name" ]] && continue
  [[ "$app_name" == "Safari" || "$app_name" == "Utilities" || "$app_name" == "System"* ]] && continue

  # Search for exact match
  result=$(brew search --casks "$search_term" | grep -Fx "$search_term")

  if [[ -n "$result" ]]; then
    # Check if already in Brewfile
    if grep -q "cask \"$search_term\"" "$BREWFILE"; then
      echo "✅ Already in Brewfile: $search_term"
    else
      echo "➕ Adding to Brewfile: cask \"$search_term\""
      echo "cask \"$search_term\"" >> "$BREWFILE"
    fi
  else
    echo "❌ Not found in Brew: $app_name"
  fi

done < "$APP_LIST"

echo "✅ Finished scanning and updating Brewfile." 