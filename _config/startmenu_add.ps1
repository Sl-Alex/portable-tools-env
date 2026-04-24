param(
    [string]$ListFile
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

$startMenu = "$env:APPDATA\Microsoft\Windows\Start Menu\Programs\PortableTools"

function Resolve($v) {
    if ([string]::IsNullOrWhiteSpace($v)) { return $null }
    return $v.Replace('$BASE$', $base).Trim()
}

New-Item -ItemType Directory -Force -Path $startMenu | Out-Null

Get-Content $ListFile |
Where-Object { $_ -and $_.Trim() -ne "" -and -not $_.Trim().StartsWith("#") } |
ForEach-Object {

    $line = $_.Trim()

    # skip empty lines
    if (-not $line) { return }

    # skip comments
    if ($line.StartsWith("#")) { return }

    $parts = $line -split "`t+"

    $title = $parts[0].Trim()
    $exe   = Resolve $parts[1]
    $icon  = if ($parts.Count -ge 3) { Resolve $parts[2] } else { $null }

    Write-Host "[ADD] $title - $exe"

    $shell = New-Object -ComObject WScript.Shell
    $sc = $shell.CreateShortcut("$startMenu\$title.lnk")

    $sc.TargetPath = $exe
    $sc.WorkingDirectory = Split-Path $exe

    if ($icon) {
        $sc.IconLocation = $icon
    }

    $sc.Save()
}

Write-Host ""
