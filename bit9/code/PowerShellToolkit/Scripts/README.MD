# CB Protection API Toolkit for PowerShell
This toolkit was written specifically for PowerShell 5.1. As such, it uses code that is NOT compatible with anything below 5.0. There could potentially be issues if you use 5.0 as I have only tested it in 5.1.

## CBEPAPICreateConfigFile.ps1
This is a script that creates a json data file in the user's temp directory with encrypted variables needed to enter a session.
These variables can only be decoded with the user account on the specific machine that they are encrypted on.

### How to use
Keep the PowerShellToolKit folder together, this is critical for the script to find the classes needed.
Call the script from a PowerShell window
```
.\CBEPAPICreateConfigFile.ps1 -url cbep.server.com -key 123-456-789
```
