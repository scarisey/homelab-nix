#!/usr/bin/env bash
set -e

# Configuration
PACKAGE_NAME="coreruleset"
FILE_PATH="packages/coreruleset/default.nix"

echo "Updating $PACKAGE_NAME..."

sed -i 's|hash = ".*";|hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";|' "$FILE_PATH"

OUTPUT=$(nix build .#packages.x86_64-linux.$PACKAGE_NAME 2>&1 || true)

NEW_HASH=$(echo "$OUTPUT" | grep "got:" | awk '{print $2}' | tr -d '[:space:]')

if [ -z "$NEW_HASH" ]; then
  echo "Failed to extract new hash. Output was:"
  echo "$OUTPUT"
  exit 1
fi

echo "Found new hash: $NEW_HASH"

sed -i "s|hash = \".*\";|hash = \"$NEW_HASH\";|" "$FILE_PATH"

echo "Update complete."
