#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/etc/nixos"
cd "$REPO_DIR"

echo "Cleaning up local state..."
# -f: force, -d: directories, -x: ignored files
git clean -fdx 

echo "Fetching latest changes..."
git fetch origin

echo "Resetting to remote HEAD..."
# This makes your local branch an exact copy of the remote
git reset --hard origin/$(git branch --show-current)

echo "System repo is now synced and clean."
