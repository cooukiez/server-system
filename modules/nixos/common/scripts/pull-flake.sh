#!/usr/bin/env bash
set -e

REPO_URL="https://github.com/cooukiez/server-system/archive/refs/heads/main.zip"
TMP_DIR="/tmp/repo_update"
TARGET_DIR="/etc/nixos"

# cleanup previous tmp dir
rm -rf "$TMP_DIR"
mkdir -p "$TMP_DIR"

# download repo zip
wget -O "$TMP_DIR/repo.zip" "$REPO_URL"

# extract zip
unzip -o "$TMP_DIR/repo.zip" -d "$TMP_DIR"

# find the extracted folder (usually repo-main)
EXTRACTED_DIR=$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d)

# copy everything to /etc/nixos, overwriting
cp -rT "$EXTRACTED_DIR" "$TARGET_DIR"

# cleanup
rm -rf "$TMP_DIR"

echo "Repo files updated in $TARGET_DIR."