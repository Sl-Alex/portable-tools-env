param(
    [string]$ListFile
)

$ErrorActionPreference = "Stop"

# base folder = where portable system lives
. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

# =====================================================
# helper: resolve $BASE$
# =====================================================
function Resolve-PathTemplate($p, $base) {
    if ([string]::IsNullOrWhiteSpace($p)) { return $null }

    return $p.Replace('$BASE$', $base).Trim()
}

# =====================================================
# current PATH
# =====================================================
$current = [Environment]::GetEnvironmentVariable("Path", "User")

$currentList =
    if ($current) { $current -split ';' } else { @() }

# normalize set
$set = [System.Collections.Generic.HashSet[string]]::new(
    [System.StringComparer]::OrdinalIgnoreCase
)

$result = @()

foreach ($p in $currentList) {
    if ($p -and $p.Trim()) {
        $norm = $p.Trim()
        if ($set.Add($norm)) {
            $result += $norm
        }
    }
}

# =====================================================
# read list
# =====================================================
$newItems =
    Get-Content $ListFile |
    Where-Object { $_ -and $_.Trim() -ne "" } |
    ForEach-Object { Resolve-PathTemplate $_ $base }

# =====================================================
# add
# =====================================================
foreach ($p in $newItems) {

    if (-not $p) { continue }

    if ($set.Add($p)) {
        Write-Host "[ADD ] $p"
        $result += $p
    }
    else {
        Write-Host "[SKIP] $p"
    }
}

# =====================================================
# final cleanup
# =====================================================
$result =
    $result |
    ForEach-Object { $_.Trim() } |
    Where-Object { $_ -ne "" }

# =====================================================
# write back
# =====================================================
$newPath = ($result -join ';')

[Environment]::SetEnvironmentVariable("Path", $newPath, "User")

Write-Host ""
