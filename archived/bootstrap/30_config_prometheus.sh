#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

print_section "Configuring Prometheus Scrape Targets"

kubectl apply -n monitoring -f - <<EOF
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: prediction-app
  labels:
    release: prometheus
spec:
  selector:
    matchLabels:
      app: prediction-app
  endpoints:
    - port: 8000
      path: /metrics
      interval: 15s
EOF
