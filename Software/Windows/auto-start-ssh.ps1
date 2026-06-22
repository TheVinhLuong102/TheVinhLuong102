#Requires -Version 5.1
<#
.SYNOPSIS
  Enable and start the Windows OpenSSH Authentication Agent (ssh-agent).

.DESCRIPTION
  Sets the OpenSSH Authentication Agent service to Automatic and starts it so
  BuildKit / Docker and Git can use `ssh-add` and forwarded SSH credentials.

  Run auto-start-ssh.bat as Administrator once (or whenever the service was
  disabled). Do not rely on this script for `ssh-add`: run `ssh-add` in a
  normal (non-elevated) shell after sign-in so keys land in your interactive
  session the same way Docker Desktop expects.

.NOTES
  Service name: ssh-agent (DisplayName: OpenSSH Authentication Agent)
#>

$ErrorActionPreference = 'Stop'

$currentPrincipal = New-Object Security.Principal.WindowsPrincipal(
    [Security.Principal.WindowsIdentity]::GetCurrent()
)
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Host 'ERROR: This script must run as Administrator.' -ForegroundColor Red
    Write-Host 'Right-click auto-start-ssh.bat -> Run as administrator.' -ForegroundColor Yellow
    exit 1
}

$serviceName = 'ssh-agent'
$service = Get-Service -Name $serviceName -ErrorAction Stop

Write-Host "Configuring service: $($service.DisplayName) ($serviceName) ..." -ForegroundColor Cyan

Set-Service -Name $serviceName -StartupType Automatic
Start-Service -Name $serviceName

Get-Service -Name $serviceName | Format-List Name, DisplayName, Status, StartType

Write-Host ''
Write-Host 'Done. In a normal (non-admin) PowerShell window, load your GitHub key, e.g.:' -ForegroundColor Green
Write-Host "  ssh-add `$env:USERPROFILE\.ssh\Dana" -ForegroundColor Gray
Write-Host '  ssh-add -l' -ForegroundColor Gray
Write-Host '  ssh -T git@github.com' -ForegroundColor Gray
Write-Host ''
exit 0
