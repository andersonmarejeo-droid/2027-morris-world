param([switch]$BuildRelease)

$ErrorActionPreference = 'Stop'
$project = Split-Path -Parent $PSScriptRoot
Set-Location $project

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw "Flutter was not found on PATH. Confirm that 'flutter --version' works."
}
if ($project -match '[^\x00-\x7F]') {
  throw "Project path contains non-ASCII characters: $project"
}

function Invoke-FlutterStep {
  param([string]$Label, [string[]]$Arguments)
  Write-Host $Label -ForegroundColor Cyan
  & flutter @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "Flutter command failed (exit=$LASTEXITCODE): flutter $($Arguments -join ' ')"
  }
}

$total = if ($BuildRelease) { 8 } else { 7 }
$step = 1
Invoke-FlutterStep "[$step/$total] flutter pub get" @('pub','get'); $step++
Invoke-FlutterStep "[$step/$total] flutter gen-l10n" @('gen-l10n'); $step++
Invoke-FlutterStep "[$step/$total] flutter analyze" @('analyze'); $step++
Invoke-FlutterStep "[$step/$total] flutter test" @('test'); $step++

Write-Host "[$step/$total] architecture scan" -ForegroundColor Cyan
$forbidden = @(
  @{ Pattern = '\bScaffold\s*\('; Name = 'direct Scaffold' },
  @{ Pattern = 'Navigator\.(push|pushNamed|pushReplacement)'; Name = 'direct Navigator push' },
  @{ Pattern = 'HapticFeedback\.'; Name = 'direct haptics' },
  @{ Pattern = 'SystemSound\.'; Name = 'direct system sound' },
  @{ Pattern = 'AudioPlayer\s*\('; Name = 'direct audio player' },
  @{ Pattern = 'showModalBottomSheet\s*<'; Name = 'direct bottom sheet' },
  @{ Pattern = 'showDialog\s*<'; Name = 'direct dialog' },
  @{ Pattern = 'Duration\s*\(milliseconds:'; Name = 'custom animation duration' },
  @{ Pattern = 'Text\s*\(\s*["'']'; Name = 'hardcoded visible Text' }
)
$violations = @()
Get-ChildItem (Join-Path $project 'lib\features') -Filter *.dart -Recurse | ForEach-Object {
  $text = Get-Content $_.FullName -Raw
  foreach ($rule in $forbidden) {
    if ($text -match $rule.Pattern) { $violations += "$($_.FullName) -> $($rule.Name)" }
  }
}
if ($violations.Count -gt 0) {
  $violations | ForEach-Object { Write-Host $_ -ForegroundColor Red }
  throw 'Architecture contract violated.'
}
$step++

Write-Host "[$step/$total] localization + audio contract" -ForegroundColor Cyan
$arbFiles = Get-ChildItem (Join-Path $project 'lib\l10n') -Filter 'app_*.arb'
if ($arbFiles.Count -ne 9) { throw "Expected 9 ARB locales, found $($arbFiles.Count)." }
$requiredAudio = @('piece_pick.wav','piece_drop.wav','slide_wood.wav','slide_marble.wav','slide_stone.wav','mill.wav','capture.wav','success.wav','button.wav')
foreach ($name in $requiredAudio) {
  if (-not (Test-Path (Join-Path $project "assets\audio\$name"))) { throw "Missing audio asset: $name" }
}
$step++

Write-Host "[$step/$total] online security contract" -ForegroundColor Cyan
$dbRules = Get-Content (Join-Path $project 'database.rules.json') -Raw
$fsRules = Get-Content (Join-Path $project 'firestore.rules') -Raw
$functionIndex = Get-Content (Join-Path $project 'functions\src\index.ts') -Raw
$serverMorris = Get-Content (Join-Path $project 'functions\src\morris.ts') -Raw
if ($dbRules -notmatch '"liveMatches"' -or $dbRules -notmatch '"\.write"\s*:\s*false') {
  throw 'Realtime Database live match write lock is missing.'
}
if ($fsRules -notmatch 'allow write: if false') {
  throw 'Firestore trusted-backend write lock is missing.'
}
if ($functionIndex -notmatch 'applyMorrisCommand' -or $functionIndex -notmatch 'expectedRevision') {
  throw 'Server-authoritative move validator is not wired into submitMove.'
}
if ($functionIndex -notmatch 'enforceAppCheck:\s*true') {
  throw 'Cloud Functions App Check enforcement contract is missing.'
}
if ($serverMorris -notmatch 'export function applyMorrisCommand') {
  throw 'Deterministic server Morris validator is missing.'
}
$step++

if ($BuildRelease) {
  Invoke-FlutterStep "[$step/$total] flutter build apk --release" @('build','apk','--release')
  $apk = Join-Path $project 'build\app\outputs\flutter-apk\app-release.apk'
  if (-not (Test-Path $apk)) { throw 'Release APK was not produced.' }
  $desktop = [Environment]::GetFolderPath('Desktop')
  $out = Join-Path $desktop 'MorrisWorld_v1.0.0_20Sprint_release.apk'
  Copy-Item -LiteralPath $apk -Destination $out -Force
  Write-Host "APK: $out" -ForegroundColor Green
}

Write-Host ''
Write-Host 'MORRIS WORLD v1.0.0 / 20 SPRINT QUALITY GATE: OK' -ForegroundColor Green
