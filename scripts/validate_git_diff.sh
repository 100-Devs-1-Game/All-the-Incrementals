#!/usr/bin/env bash
set -euo pipefail

# Get list of modified/staged/deleted files, ignoring untracsked (??) and ignored (!!)
modified_files=$(git status --porcelain | grep -Ev '^\?\? |^!! ' || true)

echo "#####################"
echo "       RESULTS       "
echo "#####################"
if [[ -n "$modified_files" ]]; then
    echo "CI FAILED DUE TO THESE MODIFIED FILES:"
    echo "$modified_files"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    echo "THE GIT DIFF:"
    echo "$(git diff || true)"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    exit 1
else
    echo "ALL GOOD :) :) :)"
    echo ""
    echo ""
    echo ""
    echo ""
    echo ""
    exit 0
fi
