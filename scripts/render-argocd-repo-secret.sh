#!/usr/bin/env bash
set -euo pipefail

if [[ ! -f .env ]]; then
  echo "Missing .env. Expected ARGOCD_REPO_URL, ARGOCD_REPO_NAME, GITHUB_USERNAME, GITHUB_TOKEN" >&2
  exit 1
fi
. ./.env

missing=()
for v in ARGOCD_REPO_URL ARGOCD_REPO_NAME GITHUB_USERNAME GITHUB_TOKEN; do
  if [[ -z "${!v:-}" ]]; then missing+=("$v"); fi
done
if (( ${#missing[@]} > 0 )); then
  echo "Missing variables: ${missing[*]}" >&2
  exit 1
fi

TEMPLATE="helm/templates/argocd-repo-secret.yaml"
OUT_FILE="helm/rendered/argocd-repo-secret.yaml"

export ARGOCD_REPO_URL ARGOCD_REPO_NAME GITHUB_USERNAME GITHUB_TOKEN

mkdir -p helm/rendered
envsubst < "$TEMPLATE" > "$OUT_FILE"
echo "Rendered $OUT_FILE"
