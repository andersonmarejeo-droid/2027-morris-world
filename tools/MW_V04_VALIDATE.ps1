param([switch]$BuildRelease)

$ErrorActionPreference = "Stop"
$project = Split-Path -Parent $PSScriptRoot
Set-Location $project

if (-not (Get-Command flutter -ErrorAction SilentlyContinue)) {
  throw "Flutter was not found on PATH. Confirm that 'flutter --version' works in the Android Studio terminal."
}

# Flutter 3.47 analysis-server regression: non-ASCII project paths may crash flutter analyze.
if ($project -match '[^\x00-\x7F]') {
  throw "Project path contains non-ASCII characters: $project`nMove the project to an ASCII-only path such as C:\Users\GiresuN\StudioProjects\morris_world and run this script there."
}

function Invoke-FlutterStep {
  param(
    [Parameter(Mandatory=$true)][string]$Label,
    [Parameter(Mandatory=$true)][string[]]$Arguments
  )

  Write-Host $Label -ForegroundColor Cyan
  & flutter @Arguments
  if ($LASTEXITCODE -ne 0) {
    throw "Flutter command failed (exit=$LASTEXITCODE): flutter $($Arguments -join ' ')"
  }
}

$total = if ($BuildRelease) { 7 } else { 6 }
$step = 1

Invoke-FlutterStep "[$step/$total] flutter pub get" @('pub','get')
$step++

Invoke-FlutterStep "[$step/$total] flutter gen-l10n" @('gen-l10n')
$step++

Invoke-FlutterStep "[$step/$total] flutter analyze" @('analyze')
$step++

Invoke-FlutterStep "[$step/$total] flutter test" @('test')
$step++

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
$featureFiles = Get-ChildItem (Join-Path $project 'lib\features') -Filter *.dart -Recurse
$violations = @()
foreach ($file in $featureFiles) {
  $text = Get-Content $file.FullName -Raw
  foreach ($rule in $forbidden) {
    if ($text -match $rule.Pattern) {
      $violations += "$($file.FullName) -> $($rule.Name)"
    }
  }
}
if ($violations.Count -gt 0) {
  $violations | ForEach-Object { Write-Host $_ -ForegroundColor Red }
  throw "Master Foundation architecture contract violated."
}
$step++

Write-Host "[$step/$total] AI contract scan" -ForegroundColor Cyan
$aiPath = Join-Path $project 'lib\core\ai\morris_ai.dart'
if (-not (Test-Path $aiPath)) {
  throw "AI engine file is missing: $aiPath"
}
$aiSource = Get-Content $aiPath -Raw
foreach ($requiredCall in @('MorrisEngine.place', 'MorrisEngine.move', 'MorrisEngine.capture')) {
  if ($aiSource -notmatch [regex]::Escape($requiredCall)) {
    throw "AI contract is incomplete: missing $requiredCall"
  }
}
if ($aiSource -match 'board\s*\[[^\]]+\]\s*=(?!=)') {
  throw "AI contract violated: AI must not mutate board cells directly."
}
$step++

if ($BuildRelease) {
  Invoke-FlutterStep "[$step/$total] flutter build apk --release" @('build','apk','--release')
}

Write-Host "V0.4 OFFLINE AI: OK" -ForegroundColor Green
