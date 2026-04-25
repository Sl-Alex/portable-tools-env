param(
    [string]$ListFile
)

$ErrorActionPreference = "Stop"

. "$PSScriptRoot\common.ps1"
$base = Get-PortableRoot

function Resolve($v) {
    return $v.Replace('$BASE$', $base)
}

Get-Content $ListFile | ForEach-Object {

    $line = $_.Trim()

    if (-not $line -or $line.StartsWith("#")) {
        return
    }

    $parts = $line -split "`t+"

    if ($parts.Count -lt 2) {
        return
    }

    $left  = $parts[0].Trim()
    $right = $parts[1].Trim()

    # extension -> ProgID
    if ($left.StartsWith(".")) {

        $ext  = $left
        $prog = $right

        Write-Host "[FTA] $ext - $prog"

        & "$base\SetUserFTA\SetUserFTA.exe" $ext $prog
    }
    else {

        $prog = $left
        $cmd  = Resolve($right)

        Write-Host "[PROG] $prog - $cmd"

		$null = & "$base\ProgIDTool\ProgIDTool.exe" register HKCU $prog $cmd -force
    }
}

Write-Host ""
