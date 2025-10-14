#!/usr/bin/env bash
set -e

cd "$(dirname "$0")"
source "$(dirname "$0")/utils.sh"

print_section "Bootstrap sequence started"

./00_wait_for_ready.sh
# ./10_config_jenkins.sh
# ./20_config_prometheus.sh
# ./30_config_grafana.sh

print_section "Bootstrap completed successfully"
