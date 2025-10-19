#!/usr/bin/env bash
set -euo pipefail

METRICS_FILE="${1:-./metrics.json}"
: "${GRAFANA_URL:?GRAFANA_URL is required}"
: "${GRAFANA_API_TOKEN:?GRAFANA_API_TOKEN is required}"

echo "==> Pushing datasource and dashboard to Grafana (redacted)…"

# Create/update a simple JSON datasource (via HTTP API). Adjust type as needed.
curl -sS -X POST "${GRAFANA_URL}/api/datasources" \
  -H "Authorization: Bearer ${GRAFANA_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data-binary @scripts/grafana-datasource.json \
  | jq '. | {message: .message // "ok"}' || true

# Import dashboard with placeholders; Grafana will upsert when 'overwrite': true
jq -n --argfile db scripts/grafana-dashboard.json '{
  dashboard: $db,
  folderUid: null,
  overwrite: true,
  message: "Automated import (redacted)"
}' > /tmp/dashboard_import.json

curl -sS -X POST "${GRAFANA_URL}/api/dashboards/db" \
  -H "Authorization: Bearer ${GRAFANA_API_TOKEN}" \
  -H "Content-Type: application/json" \
  --data-binary @/tmp/dashboard_import.json \
  | jq '.status // "ok"' || true

echo "==> Done. Verify in Grafana UI."
