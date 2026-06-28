<#
.SYNOPSIS
Installs the Ultimate Developer Cockpit

.DESCRIPTION
This script sets up WezTerm, installs necessary fonts to the current user's profile,
and provisions the WSL environment with LazyVim, Zellij, Starship, and AIChat.
#>

$ErrorActionPreference = "Stop"

Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "🚀 INITIALIZING DEVELOPER COCKPIT SETUP 🚀" -ForegroundColor Cyan
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host ""

# 1. WezTerm Setup
Write-Host "[1/4] Linking WezTerm Configuration..." -ForegroundColor Yellow
$weztermConfigPath = Join-Path $HOME ".wezterm.lua"
if (Test-Path ".\.wezterm.lua") {
    Copy-Item ".\.wezterm.lua" -Destination $weztermConfigPath -Force
    Write-Host "      ✅ .wezterm.lua copied to $HOME" -ForegroundColor Green
} else {
    Write-Host "      ⚠️ Could not find .wezterm.lua in current directory" -ForegroundColor Red
}

# 2. Font Installation (Per-User)
Write-Host "[2/4] Installing JetBrainsMono Nerd Fonts..." -ForegroundColor Yellow
$fontZip = ".\fonts\JetBrainsMono.zip"
$fontDir = ".\fonts\JetBrainsMono"
$userFontDir = "$env:LOCALAPPDATA\Microsoft\Windows\Fonts"

if (-Not (Test-Path $fontDir)) {
    if (-Not (Test-Path ".\fonts")) { New-Item -ItemType Directory -Force -Path ".\fonts" | Out-Null }
    if (-Not (Test-Path $fontZip)) {
        Write-Host "      Downloading JetBrainsMono font (this may take a minute)..." -ForegroundColor DarkGray
        Invoke-WebRequest -Uri "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" -OutFile $fontZip
    }
    Expand-Archive -Path $fontZip -DestinationPath $fontDir -Force
}

if (Test-Path $fontDir) {
    if (-Not (Test-Path $userFontDir)) {
        New-Item -ItemType Directory -Force -Path $userFontDir | Out-Null
    }
    
    $fonts = Get-ChildItem -Path $fontDir -Filter *.ttf
    $fontInstalled = $false
    foreach ($font in $fonts) {
        $destPath = Join-Path $userFontDir $font.Name
        if (-Not (Test-Path $destPath)) {
            Copy-Item $font.FullName -Destination $destPath -Force
            # Add to Registry
            $registryPath = "HKCU:\Software\Microsoft\Windows NT\CurrentVersion\Fonts"
            $fontName = $font.BaseName + " (TrueType)"
            Set-ItemProperty -Path $registryPath -Name $fontName -Value $destPath
            $fontInstalled = $true
        }
    }
    if ($fontInstalled) {
        Write-Host "      ✅ Fonts installed successfully!" -ForegroundColor Green
    } else {
        Write-Host "      ✅ Fonts are already installed." -ForegroundColor Green
    }
}

# 3. WSL Root Bootstrap
Write-Host "[3/4] Bootstrapping WSL (Root Dependencies)..." -ForegroundColor Yellow
Write-Host "      (This may take a few minutes and require your WSL password)" -ForegroundColor DarkGray
wsl -d Ubuntu -u root -- bash /mnt/d/myterminal/scripts/bootstrap_wsl.sh
wsl -d Ubuntu -u root -- bash /mnt/d/myterminal/scripts/install_cockpit_tools.sh
wsl -d Ubuntu -u root -- bash /mnt/d/myterminal/scripts/install_polish.sh
wsl -d Ubuntu -u root -- bash /mnt/d/myterminal/scripts/install_aichat.sh

# 4. WSL User Bootstrap
Write-Host "[4/4] Setting up User Tools and Dotfiles..." -ForegroundColor Yellow
# Run as default user
wsl -d Ubuntu -- bash /mnt/d/myterminal/scripts/install_lazyvim.sh
wsl -d Ubuntu -- bash /mnt/d/myterminal/scripts/setup_dotfiles.sh

Write-Host ""
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "🎉 DEVELOPER COCKPIT SETUP COMPLETE! 🎉" -ForegroundColor Green
Write-Host "==========================================" -ForegroundColor Cyan
Write-Host "Close this terminal and open WezTerm to start flying."
