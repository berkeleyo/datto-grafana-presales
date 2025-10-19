# Architecture

## Components
- **Datto DRaaS/BCDR SaaS API** — source of truth for backup/restore job status and asset inventory.
- **Integration Collector (scripts/)** — PowerShell/Bash scripts that pull, normalize, and write metrics to JSON.
- **Grafana** — visualizes metrics, alerts on thresholds, and shares read-only views.

## Data Flow
1. Collector authenticates to the Datto API using an **API key provided via environment variable**.
2. Metrics are normalized to a vendor-neutral JSON schema.
3. Grafana ingests JSON via a suitable data source (file, simple backend, or push API).

## Refresh Cadence
- For demo, on-demand.
- For POC/production, schedule using a job (e.g., GitHub Actions, cron), keeping secrets in a vault.

## Security Controls
- No secrets in repo.
- Only HTTPS.
- Principle of least privilege for API tokens.
- Optional: use a proxy or gateway to obfuscate origin IPs.

## Extensibility
- Replace the local JSON store with your preferred backend (InfluxDB, Loki, Prometheus-compatible endpoint).
- Add annotations from incident systems or change calendars.
