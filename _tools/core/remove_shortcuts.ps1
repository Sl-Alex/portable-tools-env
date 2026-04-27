param(
    [string]$TargetFolder
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

if (-not $TargetFolder) {
    throw "TargetFolder not specified"
}

if (-not (Test-Path $TargetFolder)) {
    Write-Host ""
    return
}

$shell = New-Object -ComObject WScript.Shell

Get-ChildItem -Path $TargetFolder -Filter *.lnk -File | ForEach-Object {

    $lnkPath = $_.FullName

    try {

        $shortcut = $shell.CreateShortcut($lnkPath)
        $target   = $shortcut.TargetPath

        if ([string]::IsNullOrWhiteSpace($target)) {
            return
        }

        $target = $target.Trim()

        if ($target.StartsWith($base, [System.StringComparison]::OrdinalIgnoreCase)) {

            Write-Host "[DEL] $($_.Name) - $target"

            Remove-Item $lnkPath -Force -ErrorAction SilentlyContinue
        }
    }
    catch {
        Write-Host "[SKIP] unreadable shortcut - $($_.Name)"
    }
}

Write-Host ""
