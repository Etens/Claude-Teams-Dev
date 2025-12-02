<#
.SYNOPSIS
    Installe le workflow Claude-Teams-Dev dans un projet existant.

.DESCRIPTION
    Ce script telecharge et configure le systeme de workflow multi-instances
    Claude Code dans le repertoire courant.

.PARAMETER Force
    Ecrase les fichiers existants sans confirmation.

.EXAMPLE
    irm https://raw.githubusercontent.com/Etens/Claude-Teams-Dev/main/install.ps1 | iex
#>

param(
    [switch]$Force
)

$ErrorActionPreference = "Stop"

$repo_base = "https://raw.githubusercontent.com/Etens/Claude-Teams-Dev/main"

$files = @{
    ".claude/commands/workflow-start.md" = "$repo_base/commands/workflow-start.md"
    ".claude/commands/workflow-status.md" = "$repo_base/commands/workflow-status.md"
    ".claude/agents/reviewer.md" = "$repo_base/agents/reviewer.md"
    ".claude/agents/qa.md" = "$repo_base/agents/qa.md"
    ".claude/agents/debugger.md" = "$repo_base/agents/debugger.md"
    ".claude/settings.json" = "$repo_base/templates/settings.json"
    ".workflow/scripts/notify_po.ps1" = "$repo_base/scripts/notify_po.ps1"
    ".workflow/prompts/po_system.md" = "$repo_base/prompts/po_system.md"
    ".workflow/prompts/dev_system.md" = "$repo_base/prompts/dev_system.md"
    "CLAUDE.md" = "$repo_base/templates/CLAUDE.md"
}

$directories = @(
    ".claude/commands"
    ".claude/agents"
    ".workflow/scripts"
    ".workflow/prompts"
    ".workflow/instances"
)

function Write-Status {
    param([string]$Message, [string]$Type = "Info")

    switch ($Type) {
        "Success" { Write-Host "[OK] $Message" -ForegroundColor Green }
        "Warning" { Write-Host "[!] $Message" -ForegroundColor Yellow }
        "Error" { Write-Host "[X] $Message" -ForegroundColor Red }
        default { Write-Host "[*] $Message" -ForegroundColor Cyan }
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Magenta
Write-Host "  Claude-Teams-Dev Installer" -ForegroundColor Magenta
Write-Host "========================================" -ForegroundColor Magenta
Write-Host ""

Write-Status "Creation des repertoires..."

foreach ($dir in $directories) {
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
        Write-Status "Cree: $dir" "Success"
    } else {
        Write-Status "Existe: $dir" "Warning"
    }
}

Write-Host ""
Write-Status "Telechargement des fichiers..."

foreach ($local_path in $files.Keys) {
    $url = $files[$local_path]

    if ((Test-Path $local_path) -and -not $Force) {
        Write-Status "Ignore (existe): $local_path" "Warning"
        continue
    }

    try {
        $content = Invoke-WebRequest -Uri $url -UseBasicParsing
        Set-Content -Path $local_path -Value $content.Content -Encoding UTF8
        Write-Status "Telecharge: $local_path" "Success"
    }
    catch {
        Write-Status "Echec: $local_path - $_" "Error"
    }
}

$gitignore_entries = @(
    ".workflow/instances/"
    ".workflow/notifications.jsonl"
    ".workflow/po_alerts.log"
)

$gitignore_path = ".gitignore"

Write-Host ""
Write-Status "Mise a jour du .gitignore..."

if (Test-Path $gitignore_path) {
    $gitignore_content = Get-Content $gitignore_path -Raw
} else {
    $gitignore_content = ""
}

$added = 0
foreach ($entry in $gitignore_entries) {
    if ($gitignore_content -notmatch [regex]::Escape($entry)) {
        Add-Content -Path $gitignore_path -Value $entry
        $added++
    }
}

if ($added -gt 0) {
    Write-Status "Ajoute $added entrees au .gitignore" "Success"
} else {
    Write-Status ".gitignore deja configure" "Warning"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Installation terminee !" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
Write-Host "Pour demarrer le workflow:" -ForegroundColor White
Write-Host "  1. Lancez Claude Code: claude" -ForegroundColor Gray
Write-Host "  2. Tapez: /workflow-start" -ForegroundColor Gray
Write-Host ""
