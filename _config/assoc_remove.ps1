param(
    [string]$ListFile
)

$ErrorActionPreference = "Stop"

# base (for tools location)
. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

# tools
$setUserFta = Join-Path $base "SetUserFTA\SetUserFTA.exe"
$progIdTool = Join-Path $base "ProgIDTool\ProgIDTool.exe"

function Invoke-Tool($cmd, $args) {
    & $cmd @args
}

Get-Content $ListFile |
ForEach-Object {

    $line = $_.Trim()

    if (-not $line -or $line.StartsWith("#")) {
        return
    }

    $parts = $line -split "`t+"

    if ($parts.Count -lt 2) {
        return
    }

    $left = $parts[0].Trim()

    if ($left.StartsWith(".")) {

        Write-Host "[DEL] extension $left"

        Invoke-Tool $setUserFta @("del", $left)
    }

    else {

        Write-Host "[DEL] ProgID $left"

        Invoke-Tool $progIdTool @("delete", "HKCU", $left)
    }
}

Write-Host ""
