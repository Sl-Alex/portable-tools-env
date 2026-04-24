param(
    [string]$ListFile
)

$ErrorActionPreference = "Stop"

# =====================================================
# BASE for template resolution
# =====================================================
. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

function Resolve-PathTemplate($p, $base) {
    if ([string]::IsNullOrWhiteSpace($p)) { return $null }
    return $p.Replace('$BASE$', $base).Trim()
}

function Normalize($p) {
    if ([string]::IsNullOrWhiteSpace($p)) { return $null }
    return $p.Trim()
}

# =====================================================
# current PATH
# =====================================================
$currentRaw = [Environment]::GetEnvironmentVariable("Path", "User")

$currentList =
if ($currentRaw) {
    $currentRaw -split ';' | ForEach-Object { Normalize $_ } | Where-Object { $_ }
} else {
    @()
}

# =====================================================
# read remove list (with template resolution)
# =====================================================
if (-not (Test-Path $ListFile)) {
    throw "List not found: $ListFile"
}

$removeList =
    Get-Content $ListFile |
    Where-Object { $_ -and $_.Trim() -ne "" } |
    ForEach-Object { Resolve-PathTemplate $_ $base }

# =====================================================
# normalize sets
# =====================================================
$removeSet = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase
)

foreach ($p in $removeList) {
    if ($p) {
        $removeSet.Add($p) | Out-Null
    }
}

# =====================================================
# remove (difference operation)
# =====================================================
$result = @()

foreach ($p in $currentList) {

    if (-not $p) { continue }

    if ($removeSet.Contains($p)) {
        Write-Host "[REM] $p"
        continue
	}

    $result += $p
}

# =====================================================
# final cleanup (VERY IMPORTANT)
# =====================================================
$result =
    $result |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -ne "" } |
    Select-Object -Unique

# =====================================================
# write back
# =====================================================
$newPath = ($result -join ';')

[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

Write-Host ""
