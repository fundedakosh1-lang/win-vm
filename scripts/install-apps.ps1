#!/usr/bin/env pwsh
# Install a set of winget packages and report which ones failed.
# Usage: pwsh -File scripts/install-apps.ps1 -Apps 'Discord.Discord','Spotify.Spotify'
param(
  [string]$Apps = ''
)

$ErrorActionPreference = 'Continue'

if ([string]::IsNullOrWhiteSpace($Apps)) {
  Write-Output 'No apps requested.'
  exit 0
}

$list = $Apps -split ',' | ForEach-Object { $_.Trim() } | Where-Object { $_ -ne '' }
$failed = @()

foreach ($app in $list) {
  Write-Output "=== Installing $app ==="
  winget install --id "$app" --accept-package-agreements --accept-source-agreements
  if ($LASTEXITCODE -ne 0) {
    Write-Output "FAILED: $app (exit $LASTEXITCODE)"
    $failed += $app
  }
}

if ($failed.Count -gt 0) {
  Write-Output "Failed packages: $($failed -join ', ')"
  exit 1
}
Write-Output 'All requested packages installed.'
