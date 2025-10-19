# Rollback Plan

If anything deviates during the POC setup:

1. **Disable** any new alert rules.
2. **Revert** datasource changes to the prior known-good configuration.
3. **Remove** temporary tokens and revoke access.
4. **Restore** the prior dashboard version (Grafana keeps history).
5. **Communicate** rollback with stakeholders and capture lessons learned.
