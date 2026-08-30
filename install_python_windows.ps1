# Requires -RunAsAdministrator
[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'

Write-Host "Checking Windows environment..." -ForegroundColor Green

# Check if Python is installed.
$pythonPath = (Get-Command python -ErrorAction SilentlyContinue | Where-Object { $_.Source -notlike "*WindowsApps*" }).Source

if (-not $pythonPath) {
    Write-Host "Python3 not found. Downloading official installer..." -ForegroundColor Yellow

    $installerUrl = "https://www.python.org/ftp/python/3.12.2/python-3.12.2-amd64.exe"
    $installerPath = "$env:TEMP\python-3.12.2-amd64.exe"

    # Download the official executable installer.
    [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
    Invoke-WebRequest -Uri $installerUrl -OutFile $installerPath -UseBasicParsing

    Write-Host "Installing Python3..." -ForegroundColor Yellow

    Start-Process -FilePath $installerPath -ArgumentList "/quiet InstallAllUsers=1 PrependPath=1 Include_pip=1" -Wait

    Remove-Item -Path $installerPath -Force -ErrorAction SilentlyContinue

    # Updates PATH in the current session
    $machinePath = [System.Environment]::GetEnvironmentVariable("Path", "Machine")
    $userPath = [System.Environment]::GetEnvironmentVariable("Path", "User")
    $env:Path = "$machinePath;$userPath"
} else {
    Write-Host "[+] Python3 is already installed at: $pythonPath" -ForegroundColor Green
}

# Environment validation
try {
    $ver = & python --version 2>&1
    Write-Host "[SUCCESS] Executable ready: $ver" -ForegroundColor Green
} catch {
    Write-Host "[WARNING] Please restart the terminal process to reload PATH variables." -ForegroundColor Yellow
}

