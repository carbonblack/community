using module ..\CBEPAPIComputerClass.psm1
using module ..\CBEPAPISessionClass.psm1

<#
        .SYNOPSIS

        .DESCRIPTION

        .INPUTS

        .PARAMETER computerName

        .PARAMETER tamperProtection

        .EXAMPLE

        .NOTES
        
#>

Param(
    [parameter(
        Mandatory=$true,
        ValueFromPipeline=$true
    )
    ]
    [string[]]$computerName,
    [parameter(
        Mandatory=$true,
        ValueFromPipeline=$true
    )]
    [boolean]$tamperProtection
)

# Check to make sure the config has been run
# This will pull in the json with the encrypted values, decrypt, and create a session from them
# It also clears up the memory from the decryption process
try{
    $apiConfig = ConvertFrom-Json "$(get-content $(Join-Path $env:temp "CBEPAPIConfig.json"))"

    $CBEPSession = [CBEPSession]::new()

    $Marshal = [System.Runtime.InteropServices.Marshal]
    $BstrUrl = $Marshal::SecureStringToBSTR(($apiConfig.url | ConvertTo-SecureString))
    $BstrKey = $Marshal::SecureStringToBSTR(($apiConfig.key | ConvertTo-SecureString))

    $CBEPSession.EnterSession($Marshal::PtrToStringAuto($BstrUrl), $Marshal::PtrToStringAuto($BstrKey))

    $Marshal::ZeroFreeBSTR($BstrUrl)
    $Marshal::ZeroFreeBSTR($BstrKey)
}
catch{
    "Please run the config tool first! .\Scripts\CBEPAPICreateConfigFile.ps1"
}

$CBEPComputer = [CBEPComputer]::new()

$CBEPComputer.GetComputer($computerName, $CBEPSession)

$CBEPComputer.Computer