# Security & Redaction

- **Zero secrets** or identifiers in source control.
- **Environment variables** for all tokens/URLs; consider a secret manager in POC/prod.
- **No IPs/hostnames/tenants** appear in this repository.
- **Logging** avoids printing tokens; redact on error paths.
- **Scanning**: optionally run `git-secrets`, `trufflehog`, or `gitleaks` pre-commit.
- **Access**: grant read-only Grafana roles for viewers; editors limited to the demo team.
