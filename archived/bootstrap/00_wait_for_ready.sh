#!/usr/bin/env bash

source "$(dirname "$0")/utils.sh"

print_section "Checking Kubernetes resources readiness"

wait_for_rollout ingress-nginx ingress-nginx-controller
echo

wait_for_rollout jenkins jenkins
echo

wait_for_rollout monitoring prometheus-kube-prometheus-operator
echo

wait_for_rollout monitoring prometheus-kube-state-metrics
echo

wait_for_rollout monitoring grafana
echo

wait_for_rollout monitoring prometheus-prometheus-kube-prometheus-prometheus
echo

wait_for_rollout monitoring alertmanager-prometheus-kube-prometheus-alertmanager
echo
