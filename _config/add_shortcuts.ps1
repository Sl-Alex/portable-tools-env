param(
    [string]$ListFile,
    [string]$TargetFolder
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

function Resolve-PortablePath($p) {

    if ([string]::IsNullOrWhiteSpace($p)) {
        return $null
    }

    $p = $p.Trim()

    if ([System.IO.Path]::IsPathRooted($p)) {
        return $p
    }

    return (Join-Path $base $p)
}

if (-not $TargetFolder) {
    throw "TargetFolder not specified"
}

New-Item -ItemType Directory -Force -Path $TargetFolder | Out-Null

Get-Content $ListFile |
ForEach-Object { $_.Trim() } |
Where-Object {
    $_ -ne "" -and
    -not $_.StartsWith("#")
} |
ForEach-Object {

    $parts = $_ -split "`t+"

    if ($parts.Count -lt 2) {
        return
    }

    $title = $parts[0].Trim()
    $exe   = Resolve-PortablePath $parts[1]
    $icon  = if ($parts.Count -ge 3) { Resolve-PortablePath $parts[2] } else { $null }

    if (-not $exe) {
        return
    }

    if (-not (Test-Path $exe)) {
        Write-Host "[SKIP] missing exe - $exe"
        return
    }

    Write-Host "[ADD] $title - $exe"

    $shell = New-Object -ComObject WScript.Shell
    $sc = $shell.CreateShortcut((Join-Path $TargetFolder "$title.lnk"))

    $sc.TargetPath = $exe
    $sc.WorkingDirectory = Split-Path $exe

    if ($icon) {
        $sc.IconLocation = $icon
    }

    $sc.Save()
}

Write-Host ""
