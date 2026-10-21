# Compatibility entry point; launch behavior lives in Python.
param([switch]$Headless, [switch]$Hidden, [switch]$Mock, [switch]$PrepareOnly,
      [int]$TestSeconds=0, [string]$ConfigPath='', [string]$RuntimeRoot='')
$ErrorActionPreference='Stop'
$python = Join-Path $env:USERPROFILE '.cache/codex-runtimes/codex-primary-runtime/dependencies/python/python.exe'
if (-not (Test-Path $python)) { $python=(Get-Command python -ErrorAction Stop).Source }
$launchArgs=@((Join-Path $PSScriptRoot 'start_duel.py'))
if ($Headless) { $launchArgs+='--headless' }
if ($Hidden) { $launchArgs+='--hidden' }
if ($Mock) { $launchArgs+='--mock' }
if ($PrepareOnly) { $launchArgs+='--prepare-only' }
if ($TestSeconds -gt 0) { $launchArgs+=@('--test-seconds', "$TestSeconds") }
if ($ConfigPath) { $launchArgs+=@('--config', $ConfigPath) }
if ($RuntimeRoot) { $launchArgs+=@('--runtime-root', $RuntimeRoot) }
& $python @launchArgs
exit $LASTEXITCODE
