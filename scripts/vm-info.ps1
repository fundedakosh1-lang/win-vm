#!/usr/bin/env pwsh
# Helper for local inspection of a Windows VM started by this repo.
# Usage inside the VM (paste into the runner shell):
#   pwsh -File scripts/vm-info.ps1
$ErrorActionPreference = 'Continue'

Write-Output '=== Identity ==='
whoami
hostname

Write-Output '=== OS ==='
$os = Get-CimInstance Win32_OperatingSystem
"$($os.Caption) ($($os.Version))"
"Uptime: $((Get-Date) - $os.LastBootUpTime)"

Write-Output '=== Hardware ==='
$cpu = Get-CimInstance Win32_Processor
"CPU: $($cpu.Name) ($($cpu.NumberOfLogicalProcessors) logical)"
"RAM: $([math]::Round((Get-CimInstance Win32_ComputerSystem).TotalPhysicalMemory / 1GB, 1)) GB"
"C: free $([math]::Round((Get-PSDrive C).Free / 1GB, 1)) GB"

Write-Output '=== Tools ==='
foreach ($cmd in 'git', 'gh', 'node', 'python', 'pwsh', 'winget', 'choco') {
  $found = Get-Command $cmd -ErrorAction SilentlyContinue
  if ($found) {
    Write-Output ("{0,-8} {1}" -f $cmd, (& $cmd --version 2>$null | Select-Object -First 1))
  } else {
    Write-Output ("{0,-8} not found" -f $cmd)
  }
}

Write-Output '=== Network ==='
(Get-NetIPAddress -AddressFamily IPv4 | Where-Object { $_.IPAddress -ne '127.0.0.1' } |
  Select-Object -First 3 IPAddress, InterfaceAlias | Format-Table -AutoSize | Out-String).Trim()
