#!/usr/bin/env bash
set -euo pipefail

REPO_DIR="/etc/nixos"
cd "$REPO_DIR"

BRANCH=$(git branch --show-current)

# check if flake.lock actually has changes
if ! git diff --quiet flake.lock 2>/dev/null || ! git diff --cached --quiet flake.lock 2>/dev/null; then
    echo "Changes detected in flake.lock. Preparing to push..."
    
    git add flake.lock
    git commit -m "chore: auto-update flake.lock" -- flake.lock

    echo "Fetching and merging upstream..."
    git fetch origin
    git merge origin/"$BRANCH" -X ours --no-edit

    echo "Pushing flake.lock to remote..."
    git push origin "$BRANCH"
else
    echo "No changes found in flake.lock."
fi

echo "Running permissions fix..."
fix-perms /etc/nixos

echo "Sync complete. Local files remain unchanged in your working directory."
