ProgIDTool v1.2.1 by Christoph Kolbicz, https://kolbi.cz

10.06.2024 - Initial Version 1.0
29.07.2024 - Version 1.1: Adds rename and duplicate option
24.11.2024 - Version 1.2: Fixes a logic bug in the "copy" function
20.03.2025 - Version 1.2.1: Removes the Windows version check 

Command Line Arguments
======================

Search
======

<search-term> [HKLM|HKCU]

Example: 
ProgIDTool mysearchterm
ProgIDTool mysearchterm HKCU
ProgIDTool % HKCU

Description: Searches for file types and their associated commands containing the specified search term in either HKLM or HKCU. If you supply % as a search term, all results will be shown.

Delete
======

delete [HKLM|HKCU] <progid>

Example: 
ProgIDTool delete HKCU MyProgID

Description: Deletes the specified ProgID from either HKLM or HKCU. When deleting from HKLM, administrative privileges are required.

Copy
====

copy [HKLM|HKCU] <progid> [-force]

Example:
ProgIDTool copy HKCU MyProgID
ProgIDTool copy HKLM MyProgID -force

Description: Copies the specified ProgID from HKCU to HKLM or vice versa. When copying to HKLM, administrative privileges are required. If the destination key already exists, it can be overwritten by supplying -force.

Export
======

export [HKLM|HKCU] <progid>

Example: 
ProgIDTool export HKLM MyProgID

Description: Exports the specified ProgID and its subkeys from either HKLM or HKCU to a .reg file in the same directory of ProgIDTool.exe.

Rename
======

rename [HKLM|HKCU] <progid> <newprogid>

Example: 
ProgIDTool rename HKLM MSEdgeHTM MSEdgeHTM2

Description: Allows renaming a ProgID in the Windows Registry, requiring the root key (HKLM or HKCU), the source ProgID, and the destination ProgID. The source ProgID will not exist anymore after using this command. If the destination key already exists, it can be overwritten by supplying -force.

Duplicate
=========

duplicate [HKLM|HKCU] <progid> <newprogid>

Example: 
ProgIDTool duplicate HKLM MSEdgeHTM MSEdgeHTM2 

Description: Allows duplicating a ProgID in the Windows Registry, requiring the root key (HKLM or HKCU), the source ProgID, and the destination ProgID. The source ProgID will remain and the destination contain the same content. If the destination key already exists, it can be overwritten by supplying -force.

Register
========

register [HKLM|HKCU] <progid> <path> [-force]

Example: 
ProgIDTool register HKCU MyProgID C:\Path\To\Executable.exe

Description: Registers a new ProgID with the specified executable path. you can add arguments to the path by including the full command line in quotes. if the ProgID already exists, it can be overwritten by -force. if the path requires additional quotes, you can escape them with \ for example:

input: "\"C:\Program Files (x86)\Internet Explorer\iexplore.exe\" \"%1\""
result: "C:\Program Files (x86)\Internet Explorer\iexplore.exe" "%1"
