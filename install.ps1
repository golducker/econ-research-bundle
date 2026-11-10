# Install the econ-research skill bundle on Windows.
# Usage: powershell -ExecutionPolicy Bypass -File install.ps1 [claude|codex|gemini|all]   (default: all)
#   claude -> ~\.claude\skills   (Claude Code)
#   codex  -> ~\.agents\skills   (Codex CLI, ChatGPT desktop app)
#   gemini -> ~\.gemini\skills   (Gemini CLI)
param([string]$Target = "all")

$src = Join-Path $PSScriptRoot "skills"
$map = @{
    "claude" = @("$HOME\.claude\skills")
    "codex"  = @("$HOME\.agents\skills")
    "gemini" = @("$HOME\.gemini\skills")
    "all"    = @("$HOME\.claude\skills", "$HOME\.agents\skills", "$HOME\.gemini\skills")
}
if (-not $map.ContainsKey($Target)) {
    Write-Host "Unknown target: $Target (use claude, codex, gemini or all)"
    exit 1
}

foreach ($dest in $map[$Target]) {
    New-Item -ItemType Directory -Force -Path $dest | Out-Null
    Get-ChildItem -Path $src -Directory | ForEach-Object {
        $out = Join-Path $dest $_.Name
        if (Test-Path $out) { Remove-Item -Recurse -Force $out }
        Copy-Item -Recurse -Path $_.FullName -Destination $out
    }
    Write-Host "Installed skills into $dest"
}
Write-Host "Done. Restart your agent, then type /econ-research (Claude Code) or ask for the econ-research skill."
