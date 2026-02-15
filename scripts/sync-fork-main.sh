#!/usr/bin/env bash
set -euo pipefail

if [[ "${GITHUB_ACTIONS:-}" != "true" ]]; then
  echo "This script is intended to run in GitHub Actions. Refusing to run locally." >&2
  exit 1
fi

log() {
  printf '>> %s\n' "$*"
}

default_branch="main"
upstream_repo="openclaw/nix-openclaw"

log "Configuring upstream remote"
git remote add upstream "https://github.com/${upstream_repo}.git" 2>/dev/null || true

log "Fetching origin and upstream branches"
git fetch origin "${default_branch}" --prune
git fetch upstream "${default_branch}" --prune

origin_ref="origin/${default_branch}"
upstream_ref="upstream/${default_branch}"
origin_sha="$(git rev-parse "${origin_ref}")"
upstream_sha="$(git rev-parse "${upstream_ref}")"

log "origin/${default_branch}: ${origin_sha}"
log "upstream/${default_branch}: ${upstream_sha}"

if [[ "${origin_sha}" == "${upstream_sha}" ]]; then
  log "Fork is already up to date."
  exit 0
fi

if git merge-base --is-ancestor "${origin_sha}" "${upstream_sha}"; then
  log "Fast-forward is possible. Updating ${default_branch}."
  git checkout -B "${default_branch}" "${upstream_ref}"
  git push origin "${default_branch}"
  log "Fork synchronized successfully."
  exit 0
fi

log "Fork has diverged from upstream; skipping sync to avoid conflicts."