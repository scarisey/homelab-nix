#!/usr/bin/env bash
set -e

# Configuration
PACKAGE_NAME="nginx_ultimate_bad_bot_blocker"
FILE_PATH="packages/nginx-ultimate-bad-bot-blocker/default.nix"

echo "Updating $PACKAGE_NAME..."

sed -i 's|hash = ".*";|hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";|' "$FILE_PATH"

OUTPUT=$(nix build .#packages.x86_64-linux.$PACKAGE_NAME 2>&1 || true)

NEW_HASH=$(echo "$OUTPUT" | grep "got:" | awk '{print $2}' | tr -d '[:space:]')

if [ -z "$NEW_HASH" ]; then
  echo "No new hash found"
  echo "$OUTPUT"
  exit 0
fi

echo "Found new hash: $NEW_HASH"

sed -i "s|hash = \".*\";|hash = \"$NEW_HASH\";|" "$FILE_PATH"

echo "Update complete."
