# Check that VANTA is installed and the current repository is indexed.
$ErrorActionPreference = "Stop"

if (-not (Get-Command vanta -ErrorAction SilentlyContinue)) {
    Write-Error "vanta is not on PATH. Install it from https://vanta.aethlon.xyz/docs"
    exit 1
}

vanta --version
vanta doctor
