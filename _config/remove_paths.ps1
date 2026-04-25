param()

$ErrorActionPreference = "Stop"

# =====================================================
# portable ownership root
# =====================================================
. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

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
    $currentRaw -split ';' |
    ForEach-Object { Normalize $_ } |
    Where-Object { $_ }
}
else {
    @()
}

# =====================================================
# remove owned entries
# =====================================================
$result = @()

foreach ($p in $currentList) {

    if (-not $p) { continue }

    $normalized = Normalize $p

    if (-not $normalized) { continue }

    if ($normalized.StartsWith($base, [System.StringComparison]::OrdinalIgnoreCase)) {
        Write-Host "[DEL ] $normalized"
        continue
    }

    $result += $normalized
}

# =====================================================
# final cleanup
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
