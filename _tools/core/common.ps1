function Get-PortableRoot {

    $base = $env:PORTABLE_ROOT

    if (-not $base) {
        $base = Split-Path (Split-Path $PSScriptRoot)
    }

    return $base
}
