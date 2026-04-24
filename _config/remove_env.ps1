param(
    [string]$ListFile
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

function Resolve($v, $base) {
    if ([string]::IsNullOrWhiteSpace($v)) { return $null }
    return $v.Replace('$BASE$', $base).Trim()
}

# current env (User scope)
$current = Get-ChildItem Env: | ForEach-Object { $_.Name }

# read list
$list = Get-Content $ListFile |
    Where-Object { $_ -and $_.Trim() -ne "" }

foreach ($line in $list) {

    $line = $line.Trim()

    # skip empty lines
    if (-not $line) { return }

    # skip comments
    if ($line.StartsWith("#")) { return }

    $parts = $line -split "`t+", 2
    if ($parts.Count -ne 2) { continue }

    $key = $parts[0].Trim()
    $val = Resolve $parts[1] $base

    # skip template values
    if ($val -like "*`$BASE$*") { continue }

    Write-Host "[DEL] $key"

    [Environment]::SetEnvironmentVariable($key, $null, "User")
}