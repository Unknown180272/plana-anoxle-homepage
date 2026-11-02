#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"
for cmd in git gh; do command -v "$cmd" >/dev/null || { echo "Missing $cmd. Install with sudo apt install git gh"; exit 1; }; done
if ! gh auth status >/dev/null 2>&1; then
  echo "Login to GitHub in the browser:"; gh auth login
fi
USER="$(gh api user --jq .login)"
REPO="plana-anoxle-homepage"
echo "Publishing this folder as a PUBLIC GitHub repository: $USER/$REPO"
echo "Review files and rights to share art before continuing."
read -r -p "Type PUBLISH to proceed: " YES
[[ "$YES" == "PUBLISH" ]] || exit 1
if gh repo view "$USER/$REPO" >/dev/null 2>&1; then echo "Repository already exists; stopping to avoid overwriting."; exit 1; fi
git init -b main
git add .
git -c user.name="Homepage Publisher" -c user.email="publisher@users.noreply.github.com" commit -m "Publish Plana Anoxle Light homepage"
gh repo create "$REPO" --public --source=. --remote=origin --push
printf '
Repository: https://github.com/%s/%s
' "$USER" "$REPO"
printf 'Go to Settings > Pages > Build and deployment > Deploy from a branch > main / (root) > Save.
'
printf 'Once deployed, share: https://%s.github.io/%s/
' "$USER" "$REPO"
