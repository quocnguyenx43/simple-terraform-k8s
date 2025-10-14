#!/usr/bin/env bash
set -euo pipefail

# Load env from .env (user-provided, not committed)
if [[ ! -f .env ]]; then
  echo "Missing .env. Create it from your secrets." >&2
  exit 1
fi
. ./.env

missing=()
for v in GITHUB_USERNAME GITHUB_TOKEN DOCKERHUB_USERNAME DOCKERHUB_PASSWORD; do
  if [[ -z "${!v:-}" ]]; then missing+=("$v"); fi
done
if (( ${#missing[@]} > 0 )); then
  echo "Missing variables: ${missing[*]}" >&2
  exit 1
fi

TEMPLATE="helm/templates/jenkins-credentials.yaml"
OUT_FILE="helm/rendered/jenkins-credentials.yaml"

export GITHUB_USERNAME GITHUB_TOKEN DOCKERHUB_USERNAME DOCKERHUB_PASSWORD

mkdir -p helm/rendered
envsubst < "$TEMPLATE" > "$OUT_FILE"
echo "Rendered $OUT_FILE"
