#!/usr/bin/env bash

source "$(dirname "$0")/utils.sh"

print_section "Applying Ingress rule for Jenkins"

kubectl apply -f ingress/jenkins-ingress.yaml

print_section "Applying Ingress rule for Monitoring (Grafana & Prometheus)"

kubectl apply -f ingress/monitoring-ingress.yaml
