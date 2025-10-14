#!/usr/bin/env bash
set -e

# Colors for better logs
GREEN="\033[0;32m"
YELLOW="\033[1;33m"
RED="\033[0;31m"
CYAN="\033[0;36m"
NC="\033[0m" # No Color

# Helper logging functions
info()  { echo -e "${CYAN} $*${NC}"; }
ok()    { echo -e "${GREEN} $*${NC}"; }
warn()  { echo -e "${YELLOW} $*${NC}"; }
error() { echo -e "${RED} $*${NC}"; }

# Wait function for any resource type
wait_for_rollout() {
  local namespace=$1
  local name=$2
  local timeout=${3:-300s}

  info "Waiting for rollout of '${name}' in namespace '${namespace}'..."

  # Try Deployment first
  if kubectl get deployment "$name" -n "$namespace" &>/dev/null; then
    if kubectl rollout status deployment/"$name" -n "$namespace" --timeout="$timeout"; then
      ok "Deployment '$name' in namespace '$namespace' is ready!"
      return 0
    else
      error "Deployment '$name' in namespace '$namespace' failed to roll out!"
      return 1
    fi
  fi

  # Try StatefulSet next
  if kubectl get statefulset "$name" -n "$namespace" &>/dev/null; then
    if kubectl rollout status statefulset/"$name" -n "$namespace" --timeout="$timeout"; then
      ok "StatefulSet '$name' in namespace '$namespace' is ready!"
      return 0
    else
      error "StatefulSet '$name' in namespace '$namespace' failed to roll out!"
      return 1
    fi
  fi

  warn "Resource '$name' not found in namespace '$namespace' (skipping)"
}

function print_section() {
  echo
  echo "------------------------------------------------------"
  echo "$1"
  echo "------------------------------------------------------"
}
