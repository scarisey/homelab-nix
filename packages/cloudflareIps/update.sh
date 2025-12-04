#!/usr/bin/env bash
set -e

# Configuration
PACKAGE_NAME="cloudflareIps" # The name in your flake.nix packages
FILE_PATH="packages/cloudflareIps/default.nix" # Path to the file containing the fetchurl

echo "Updating $PACKAGE_NAME..."

# 1. Insert a dummy hash (Zero Hash)
# This forces Nix to re-download and re-process the file because the hash won't match.
sed -i 's|hash = ".*";|hash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";|' "$FILE_PATH"

# 2. Try to build and capture the error output
# We expect this to FAIL. We redirect stderr to stdout to grep it.
OUTPUT=$(nix build .#packages.x86_64-linux.$PACKAGE_NAME 2>&1 || true)

# 3. Extract the 'got' hash from the error message
# The error usually looks like: "specified: ... got: sha256-xyz..."
NEW_HASH=$(echo "$OUTPUT" | grep "got:" | awk '{print $2}' | tr -d '[:space:]')

if [ -z "$NEW_HASH" ]; then
  echo "Failed to extract new hash. Output was:"
  echo "$OUTPUT"
  exit 1
fi

echo "Found new hash: $NEW_HASH"

# 4. Update the file with the real new hash
sed -i "s|hash = \".*\";|hash = \"$NEW_HASH\";|" "$FILE_PATH"

echo "Update complete."
