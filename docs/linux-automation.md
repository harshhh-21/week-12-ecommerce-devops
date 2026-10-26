
# Linux Administration and Bash Automation

## Scripts

### 1. system_health.sh
Collects basic Linux diagnostic information:
- Operating system and hostname
- Uptime and load averages
- Memory utilization
- Filesystem utilization
- Top CPU-consuming processes
- Network interface information

### 2. generate_system_report.sh
Generates a timestamped diagnostic report under `docs/reports/`.

## Validation
- Bash syntax validation using `bash -n`
- Executable permissions verified
- Scripts executed successfully
- Generated report inspected

## Limitations
These scripts provide basic diagnostics. They do not automatically
remediate issues, send alerts, or replace production monitoring.
