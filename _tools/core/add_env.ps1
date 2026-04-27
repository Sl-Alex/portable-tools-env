param(
    [string]$ListFile
)

$ErrorActionPreference = "Stop"

# =====================================================
# BASE for templates
# =====================================================
. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

function Resolve($v, $base) {
    if ([string]::IsNullOrWhiteSpace($v)) { return $null }
    return $v.Replace('$BASE$', $base).Trim()
}

# =====================================================
# current environment (User)
# =====================================================
$current = [Environment]::GetEnvironmentVariables("User")

# =====================================================
# read env list
# =====================================================
$list =
    Get-Content $ListFile |
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
    $value = Resolve $parts[1] $base

    if ([string]::IsNullOrWhiteSpace($key)) { continue }

    Write-Host "[SET] $key = $value"

    # write to USER environment (modern API)
    [Environment]::SetEnvironmentVariable($key, $value, "User")
}

Write-Host ""
