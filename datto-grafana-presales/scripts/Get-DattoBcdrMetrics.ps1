param(
    [string]$OutFile = "./metrics.json"
)

$ErrorActionPreference = "Stop"

# Inputs via environment
$baseUrl = $env:DATTO_API_BASE_URL
$apiKey  = $env:DATTO_API_KEY

Write-Host "==> Pulling Datto DRaaS/BCDR metrics (redacted)…"

if (-not $baseUrl -or -not $apiKey) {
    Write-Warning "Environment variables DATTO_API_BASE_URL and DATTO_API_KEY not set. Writing SAFE SAMPLE data."
    $sample = @{
        pulledAt = (Get-Date).ToString("o")
        source   = "sample"
        summary  = @{
            backupSuccessRate = 97
            protectedAssets   = 42
            lastJobAgeMinutes = 18
            storageGiB        = 820
        }
        jobs = @(
            @{ id="job-001"; status="Success"; durationSec=120; sizeMiB=512; asset="server-A" },
            @{ id="job-002"; status="Warning"; durationSec=240; sizeMiB=2048; asset="server-B" },
            @{ id="job-003"; status="Failed";  durationSec=60;  sizeMiB=128;  asset="laptop-C" }
        )
    } | ConvertTo-Json -Depth 5
    $sample | Out-File -FilePath $OutFile -Encoding utf8
    Write-Host "Wrote sample metrics to $OutFile"
    exit 0
}

# Real call (placeholder endpoints; do not commit real paths)
$headers = @{
    "Authorization" = "Bearer $apiKey"
    "Accept"        = "application/json"
}

try {
    # Example placeholders — replace with actual Datto API paths as per customer NDA.
    $summaryResp = Invoke-RestMethod -Method GET -Uri "$baseUrl/v1/bcdr/summary" -Headers $headers -TimeoutSec 30
    $jobsResp    = Invoke-RestMethod -Method GET -Uri "$baseUrl/v1/bcdr/jobs?limit=100" -Headers $headers -TimeoutSec 30

    $payload = @{
        pulledAt = (Get-Date).ToString("o")
        source   = "datto-api"
        summary  = $summaryResp
        jobs     = $jobsResp.items
    } | ConvertTo-Json -Depth 6

    $payload | Out-File -FilePath $OutFile -Encoding utf8
    Write-Host "Wrote metrics to $OutFile"
}
catch {
    Write-Warning "API call failed; writing SAFE SAMPLE instead. Error: $($_.Exception.Message)"
    $sample = @{
        pulledAt = (Get-Date).ToString("o")
        source   = "sample-fallback"
        summary  = @{
            backupSuccessRate = 95
            protectedAssets   = 30
            lastJobAgeMinutes = 42
            storageGiB        = 600
        }
        jobs = @(
            @{ id="job-010"; status="Success"; durationSec=140; sizeMiB=300; asset="redacted-1" }
        )
    } | ConvertTo-Json -Depth 5
    $sample | Out-File -FilePath $OutFile -Encoding utf8
}
