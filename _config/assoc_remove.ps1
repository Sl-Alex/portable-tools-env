param(
    [string]$ListFile
)

$ErrorActionPreference = "Stop"

Get-Content $ListFile | ForEach-Object {

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

        Remove-Item "HKCU:\Software\Classes\$left" -Recurse -Force -ErrorAction SilentlyContinue
    }
    else {

        Write-Host "[DEL] ProgID $left"

        Remove-Item "HKCU:\Software\Classes\$left" -Recurse -Force -ErrorAction SilentlyContinue
    }
}

Write-Host ""
