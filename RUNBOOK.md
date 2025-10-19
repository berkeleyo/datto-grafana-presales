# RUNBOOK — Pre‑Sales Demo

This runbook guides a safe, redacted demo of **Grafana** visualizing **Datto DRaaS/BCDR** metrics.

## Prerequisites

- PowerShell 7+ and Bash (or WSL)
- Network egress to Datto API and Grafana
- Environment variables exported (never committed):
  - `DATTO_API_BASE_URL`
  - `DATTO_API_KEY`
  - `GRAFANA_URL`
  - `GRAFANA_API_TOKEN`

> Confirm no secrets are written to disk or console history.

## Steps

1. **Prepare environment**
   ```bash
   export DATTO_API_BASE_URL="https://api.example"
   export DATTO_API_KEY="<redacted>"
   export GRAFANA_URL="https://grafana.example"
   export GRAFANA_API_TOKEN="<redacted>"
   ```

2. **Pull metrics (mock-friendly)**
   ```bash
   pwsh -File ./scripts/Get-DattoBcdrMetrics.ps1 -OutFile ./metrics.json
   ```
   - Output: `metrics.json` (safe sample if API not reachable).

3. **Provision Grafana assets**
   ```bash
   bash ./scripts/push_metrics_to_grafana.sh ./metrics.json
   ```
   - Creates/updates a **JSON file-based** datasource (if using file provisioning) or calls the Grafana HTTP API.
   - Imports the example dashboard.

4. **Validate access**
   - Verify read-only access for stakeholders.
   - Review panels: backup success %, last job age, protected assets, storage growth.

5. **Demo flow**
   - Start with the **OVERVIEW**.
   - Walk through the **Architecture** and data lineage.
   - Show **alerts** and **annotations** (if configured).

6. **Handover**
   - Share this repo and the **docs/** folder.
   - Capture feedback and next steps.

## Cleanup

- Remove local `metrics.json` if it contains any customer data.
- Revoke any temporary tokens.
- Clear environment variables and shell history.

## Troubleshooting

- **401/403:** token or scope issues (Grafana or Datto).
- **SSL:** ensure TLS trust chain; avoid ignoring cert validation.
- **No data:** verify API base URL and network path; run script with `-Verbose`.
