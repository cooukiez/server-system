#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/etc/nixos"
cd "$REPO_DIR"

BRANCH=$(git branch --show-current)

echo "Resetting all files except flake.lock..."

# discard changes to all tracked files, excluding flake.lock
git checkout HEAD -- . ':(exclude)flake.lock' >/dev/null 2>&1 || true

echo "Cleaning up local state (untracked files)..."
# -f: force, -d: directories, -x: ignored files
git clean -fdx 

echo "Checking for changes in flake.lock..."
# check for both staged and unstaged changes to flake.lock relative to HEAD
if ! git diff --quiet HEAD -- flake.lock 2>/dev/null; then
    echo "Changes detected in flake.lock. Committing..."
    git add flake.lock
    git commit -m "chore: auto-update flake.lock"
else
    echo "No local changes."
fi

echo "Fetching latest changes..."
git fetch origin

echo "Syncing with upstream..."
# merge upstream changes
# (e.g., upstream also modified flake.lock), '-X theirs' forces upstream to win
git merge origin/"$BRANCH" -X theirs --no-edit -m "chore: merge upstream changes"

echo "Pushing updates to remote..."
git push origin "$BRANCH"

echo "System repo is now synced and clean."

fix-perms /etc/nixos