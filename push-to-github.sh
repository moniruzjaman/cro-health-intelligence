#!/usr/bin/env bash
# Push cro-health-intelligence to GitHub from your machine.
#
# The repo is fully committed locally with 7 logical commits. This sandbox has
# no GitHub credentials, so run this script where your GitHub auth lives
# (gh CLI, credential manager, or SSH key).
#
# Usage:
#   cd cro-health-intelligence
#   bash push-to-github.sh
set -euo pipefail

REMOTE_URL="https://github.com/moniruzjaman/cro-health-intelligence.git"

# Preferred: gh CLI (handles auth + repo creation if missing)
if command -v gh >/dev/null 2>&1 && gh auth status >/dev/null 2>&1; then
  echo "→ gh CLI authenticated; ensuring remote repo exists…"
  gh repo view moniruzjaman/cro-health-intelligence >/dev/null 2>&1 || gh repo create moniruzjaman/cro-health-intelligence --public
  git push -u origin main
  echo "✓ Pushed with gh CLI."
  exit 0
fi

# Fallback: plain HTTPS push (uses your stored git credentials / token prompt)
echo "→ gh CLI not available/authenticated; trying HTTPS push…"
if git push -u origin main; then
  echo "✓ Pushed over HTTPS."
  exit 0
fi

# Last resort: SSH
echo "→ HTTPS failed; trying SSH remote…"
git remote set-url origin git@github.com:moniruzjaman/cro-health-intelligence.git
git push -u origin main
echo "✓ Pushed over SSH."

echo
echo "Repo contents (7 commits):"
git log --oneline
