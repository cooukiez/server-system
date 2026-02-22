#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/etc/nixos"

cd "$REPO_DIR"

echo "flake.lock" >> .git/info/exclude

git stash push -u -m "stash new files before pull"
echo "Stashed untracked files."

echo "Pulling latest changes from flake..."
git pull --rebase

echo "Pull complete."

git stash pop
echo "Restored local files."
