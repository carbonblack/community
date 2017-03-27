<#
        .SYNOPSIS
        This script will create a config file that the CBEP PowerShell Toolkit will use for authentication in an API session
        .DESCRIPTION
        This script takes in the URL of the CBEP server as well as the API key of the user that will be used in the API session.
        It converts this information to secure strings and saves it to a JSON file located in the $env:Temp folder.
        .PARAMETER url
        string - This is the url of the CBEP server
        .PARAMETER key
        string - This is the API key of the user that will run the session
        .EXAMPLE
        C: <PS> .\CBEPAPICreateConfigFile.ps1 -url cbep.server.com -key 123-456-789
        .NOTES
        CB Protection API Tools for PowerShell v2.0
        Copyright (C) 2017 Thomas Brackin

        Requires: Powershell v5.1

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

Param(
    [parameter(
        Mandatory=$true
    )]
    [string[]]$url,
    [parameter(
        Mandatory=$true
    )]
    [string[]]$key,
    [parameter(
        Mandatory=$false
    )]
    [string[]]$vtkey
)
$secureValue = @{
    url=$null
    key=$null
    vtkey=$null
}

$secureValue.url = $url | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
$secureValue.key = $key | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
If ($vtkey){
    $secureValue.vtkey = $key | ConvertTo-SecureString -AsPlainText -Force | ConvertFrom-SecureString
}

Remove-Item -Path "$env:localappdata\CBConfig" -Force -ErrorAction Ignore
New-Item -Path "$env:localappdata\CBConfig" -Force -ItemType Directory

$secureValue | ConvertTo-Json | Out-File $(Join-Path $env:localappdata "CBConfig\CBEPApiConfig.json")