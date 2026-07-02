<#
.SYNOPSIS
  One-shot setup of all GitHub Actions secrets for the Diyar CI/CD pipeline.

.DESCRIPTION
  YOU run this from the repo root on Windows (PowerShell). It uses the GitHub
  CLI (`gh`) under YOUR own login, so the secret values never leave your machine
  via anyone else.

  It sets the 6 "local" secrets automatically (keystore, passwords,
  google-services.json, plist). The 4 external credentials are set only when you
  pass their parameters — so you can run this in stages.

.PREREQUISITES
  1. Install GitHub CLI:  winget install GitHub.cli
  2. Authenticate:        gh auth login
  3. Run from the repo root:  cd "E:\uis projects\Diyar-App-New"

.EXAMPLE  (stage 1 — local secrets only)
  ./ci/setup-github-secrets.ps1

.EXAMPLE  (stage 2 — add Firebase + Play once you've downloaded their JSON files)
  ./ci/setup-github-secrets.ps1 -FirebaseSaJson "$HOME\Downloads\firebase-sa.json" -PlaySaJson "$HOME\Downloads\play-sa.json"

.EXAMPLE  (stage 3 — add App Store Connect + match)
  ./ci/setup-github-secrets.ps1 `
     -AscKeyId "ABC123" -AscIssuerId "xxxx-xxxx" -AscP8 "$HOME\Downloads\AuthKey_ABC123.p8" `
     -MatchGitUrl "https://github.com/UisComp/diyar-certificates.git" `
     -MatchPassword "your-strong-passphrase" `
     -GitUser "your-github-username" -GitToken "ghp_xxx"
#>

param(
  [string]$Repo = "UisComp/Diyar-App-New",
  [string]$FirebaseSaJson,
  [string]$PlaySaJson,
  [string]$AscKeyId,
  [string]$AscIssuerId,
  [string]$AscP8,
  [string]$MatchGitUrl,
  [string]$MatchPassword,
  [string]$GitUser,
  [string]$GitToken,
  [string]$MatchGitAuth   # optional: provide ready base64 of "user:token" instead of GitUser/GitToken
)

$ErrorActionPreference = "Stop"

function Set-Secret([string]$Name, [string]$Value) {
  if ([string]::IsNullOrWhiteSpace($Value)) { Write-Host "  - skip $Name (empty)"; return }
  # gh reads the secret value from stdin when --body is omitted (handles multiline safely).
  $Value | gh secret set $Name --repo $Repo
  if ($LASTEXITCODE -eq 0) { Write-Host "  + set $Name" -ForegroundColor Green }
  else { Write-Host "  ! failed $Name" -ForegroundColor Red }
}
function Set-SecretFromFile([string]$Name, [string]$Path) {
  if (-not (Test-Path $Path)) { Write-Host "  ! file not found for $Name: $Path" -ForegroundColor Red; return }
  Set-Secret $Name (Get-Content -Raw -Path $Path)
}

# --- sanity checks --------------------------------------------------------
if (-not (Get-Command gh -ErrorAction SilentlyContinue)) {
  throw "GitHub CLI 'gh' not found. Install: winget install GitHub.cli  then: gh auth login"
}
if (-not (Test-Path "android/key.properties")) {
  throw "Run this from the repo root (android/key.properties not found)."
}

Write-Host "== Repo: $Repo ==" -ForegroundColor Cyan

# --- 1) Android keystore (base64) ----------------------------------------
Write-Host "Android keystore..."
$ksBytes  = [IO.File]::ReadAllBytes((Resolve-Path "android/app/upload-keystore.jks"))
$ksBase64 = [Convert]::ToBase64String($ksBytes)
Set-Secret "ANDROID_KEYSTORE_BASE64" $ksBase64

# --- 2) Android signing passwords (parsed from key.properties) ------------
Write-Host "Android signing passwords..."
$kp = @{}
Get-Content "android/key.properties" | ForEach-Object {
  if ($_ -match '^\s*([^=#]+?)\s*=\s*(.*)$') { $kp[$matches[1].Trim()] = $matches[2].Trim() }
}
Set-Secret "ANDROID_STORE_PASSWORD" $kp["storePassword"]
Set-Secret "ANDROID_KEY_PASSWORD"   $kp["keyPassword"]
Set-Secret "ANDROID_KEY_ALIAS"      $kp["keyAlias"]

# --- 3) Firebase / Google config files ------------------------------------
Write-Host "Firebase config files..."
Set-SecretFromFile "GOOGLE_SERVICES_JSON"          "android/app/google-services.json"
Set-SecretFromFile "IOS_GOOGLE_SERVICE_INFO_PLIST" "ios/Runner/GoogleService-Info.plist"

# --- 4) Firebase App Distribution service account (external) ---------------
if ($FirebaseSaJson) { Write-Host "Firebase service account..."; Set-SecretFromFile "FIREBASE_SERVICE_ACCOUNT_JSON" $FirebaseSaJson }

# --- 5) Google Play service account (external) -----------------------------
if ($PlaySaJson) { Write-Host "Google Play service account..."; Set-SecretFromFile "PLAY_SERVICE_ACCOUNT_JSON" $PlaySaJson }

# --- 6) App Store Connect API key (external) -------------------------------
if ($AscKeyId)    { Set-Secret "ASC_KEY_ID"    $AscKeyId }
if ($AscIssuerId) { Set-Secret "ASC_ISSUER_ID" $AscIssuerId }
if ($AscP8) {
  if (-not (Test-Path $AscP8)) { Write-Host "  ! .p8 not found: $AscP8" -ForegroundColor Red }
  else {
    $p8b64 = [Convert]::ToBase64String([IO.File]::ReadAllBytes((Resolve-Path $AscP8)))
    Set-Secret "ASC_KEY_CONTENT" $p8b64
  }
}

# --- 7) match (iOS code signing) ------------------------------------------
if ($MatchGitUrl)  { Set-Secret "MATCH_GIT_URL"  $MatchGitUrl }
if ($MatchPassword){ Set-Secret "MATCH_PASSWORD" $MatchPassword }
if (-not $MatchGitAuth -and $GitUser -and $GitToken) {
  $MatchGitAuth = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes("$GitUser`:$GitToken"))
}
if ($MatchGitAuth) { Set-Secret "MATCH_GIT_BASIC_AUTHORIZATION" $MatchGitAuth }

Write-Host ""
Write-Host "== Current secrets on $Repo ==" -ForegroundColor Cyan
gh secret list --repo $Repo
Write-Host ""
Write-Host "Done. Re-run with more parameters to add the remaining secrets." -ForegroundColor Yellow
