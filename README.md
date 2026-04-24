# Portable Environment System

## Overview

This repository provides a portable Windows environment management system.

It is designed to configure and manage:
- PATH environment variables
- user environment variables
- file associations
- Start Menu shortcuts

All configuration is defined through declarative list files and executed via PowerShell and batch scripts.

The system is portable and can be moved between machines as long as the same directory structure is preserved. Admin rights are not required, only user-related configuration is modified.

## Structure

```
install.bat        - Installs the environment configuration
uninstall.bat      - Removes installed configuration

_config/
    *.ps1          - PowerShell scripts implementing logic
    *.list         - Declarative configuration files
    *.list.example - Example configuration files used as templates for creating your own *.list files
```

Portable applications and tools should be placed in the repository root and are not tracked by Git.

## System requirements

- Windows 10 or later
- PowerShell

## Third-party utilities

The following third-party utilities are included:

- SetUserFTA  
  Used for managing file extension associations (default applications)

- ProgIDTool  
  Used for registering ProgIDs and associated commands in the Windows registry

These tools are distributed under their own non-commercial licenses.

License files for these tools are located in the same directories as their respective executables.

---

## Notes about *.list files

- `$BASE$` is resolved to `PORTABLE_ROOT`
- Configuration is idempotent where possible
- Scripts are designed for repeatable execution without side effects

---

## Git configuration

Recommended repository settings:

```bash
git config core.autocrlf false
git config core.eol crlf
```

---

## Limitations

- File association management depends on external tools and Windows internals. Some associations are protected and cannot be easily modified. This is what SetUserFTA tries to solve.
- Environment changes apply per user and may require a new session to take effect.
- Windows-only
