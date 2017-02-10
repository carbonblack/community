using module ..\CBEPAPIComputerClass.psm1
# using module ..\CBEPAPIFileClass.psm1
# using module ..\CBEPAPIPolicyClass.psm1
# using module ..\CBEPAPIPublisherClass.psm1
# using module ..\CBEPAPIRequestClass.psm1
using module ..\CBEPAPISessionClass.psm1

<#
        .SYNOPSIS
        Use this as a template for all scripts created to use with the toolkit
        .DESCRIPTION
        Uncomment out any modules are you using in this script and leave the code to check the credentials for the session
        .PARAMETER computerName

        .EXAMPLE

        .NOTES
        CB Protection API Tools for PowerShell v1.1
        Copyright (C) 2017 Thomas Brackin

        Requires: Powershell v5.1

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

Param(
    [Parameter(
        Mandatory=$true,
        ValueFromPipeline=$true
    )]
    [string[]]$computerName
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

$computerId = $CBEPComputer.GetComputer($computerName, $CBEPSession)

$CBEPComputer.DeleteComputer($computerId, $CBEPSession)