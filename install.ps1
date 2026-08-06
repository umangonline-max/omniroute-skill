# omniroute-skill installer (Windows / PowerShell) — copies SKILL.md (+ DESCRIPTION.md)
# into every agent skills directory it finds. Safe to re-run.
# Run:  powershell -ExecutionPolicy Bypass -File install.ps1
# Or:   .\install.ps1
$ErrorActionPreference = "Stop"

$srcDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillName = "omniroute"
$installed = 0

function Install-To([string]$dest) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Copy-Item "$srcDir\SKILL.md" "$dest\SKILL.md" -Force
    Copy-Item "$srcDir\DESCRIPTION.md" "$dest\DESCRIPTION.md" -Force
    Write-Host "  [ok] installed -> $dest"
    $script:installed++
}

Write-Host "Installing omniroute skill..."

# OpenCode (canonical location used by most setups)
if (Test-Path "$HOME\.agents\skills") { Install-To "$HOME\.agents\skills\$skillName" }

# Codex
if (Test-Path "$HOME\.codex\skills") { Install-To "$HOME\.codex\skills\$skillName" }

# Claude Code
if (Test-Path "$HOME\.claude") { Install-To "$HOME\.claude\skills\$skillName" }

# Hermes
if (Test-Path "$HOME\.hermes\skills") { Install-To "$HOME\.hermes\skills\$skillName" }

# OpenClaw (extension-style install)
if (Test-Path "$HOME\.openclaw\extensions") {
    Install-To "$HOME\.openclaw\extensions\$skillName\skills\$skillName"
    $manifest = @{
        name        = "omniroute"
        version     = "1.0.0"
        description = "Control and integrate with OmniRoute (self-hosted AI gateway)"
        skills      = @("skills/omniroute")
    } | ConvertTo-Json
    Set-Content -Path "$HOME\.openclaw\extensions\$skillName\openclaw.plugin.json" -Value $manifest
    Write-Host "  [ok] wrote openclaw plugin manifest -> $HOME\.openclaw\extensions\$skillName\"
    $installed++
}

if ($installed -eq 0) {
    Write-Host "No supported agent skill directories found."
    Write-Host "Manual install: copy SKILL.md into <your-agent>/skills/omniroute/"
    Write-Host "Checked: ~/.agents/skills, ~/.codex/skills, ~/.claude, ~/.hermes/skills, ~/.openclaw/extensions"
    exit 1
}

Write-Host "Done - installed into $installed location(s)."
Write-Host "Next: tell your agent to read SKILL.md (or just ask it to 'use the omniroute skill')."
