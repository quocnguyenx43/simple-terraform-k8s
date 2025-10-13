#!/usr/bin/env bash
source "$(dirname "$0")/utils.sh"

print_section "Importing Grafana Dashboards"

GRAFANA_POD=$(kubectl get pods -n monitoring -l app.kubernetes.io/name=grafana -o jsonpath='{.items[0].metadata.name}')

kubectl cp ./dashboards/default-dashboard.json monitoring/$GRAFANA_POD:/tmp/dashboard.json
kubectl exec -n monitoring $GRAFANA_POD -- curl -X POST -u admin:grafana123 \
  -H "Content-Type: application/json" \
  -d @/tmp/dashboard.json \
  http://localhost:3000/api/dashboards/db
