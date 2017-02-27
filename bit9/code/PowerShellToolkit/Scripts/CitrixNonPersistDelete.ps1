# This script is designed to run in the folder path of:
# PowerShellToolkit\Scripts\CitrixNonPersistentDelete.ps1
#
# This script depends on the following files:
# PowerShellToolkit\Classes\CBEPAPISessionClass.psm1
# PowerShellToolkit\Classes\CBEPAPIComputerClass.psm1
# PowerShellToolkit\Scripts\CBEPAPIDeleteComputer.ps1
# PowerShellToolkit\Scripts\CBEPAPICreateConfigFile.ps1

$citrixNonPersistentPrefix = "YOUR PREFIX HERE"

.\CBEPAPIDeleteComputer.ps1 -computerName ($citrixNonPersistentPrefix)