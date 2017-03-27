# using module ..\Classes\CBEPAPIComputerClass.psm1
# using module ..\Classes\CBEPAPIEventClass.psm1
# using module ..\Classes\CBEPAPIFileClass.psm1
# using module ..\Classes\CBEPAPIPolicyClass.psm1
# using module ..\Classes\CBEPAPIPublisherClass.psm1
# using module ..\Classes\CBEPAPIRequestClass.psm1
using module ..\Classes\CBEPAPISessionClass.psm1
# using module ..\Classes\CBEPAPITemplateClass.psm1
# using module ..\Classes\CBEPAPIVTAnalysisClass.psm1

<#
        .SYNOPSIS
        Use this as a template for all scripts created to use with the toolkit
        .DESCRIPTION
        Uncomment out any modules are you using in this script and leave the code to check the credentials for the session
        .PARAMETER temp

        .EXAMPLE

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

    )]
    [string]$tempParam
)

# Start default session block
# Create a session and make sure it works
$Session = [CBEPSession]::new()
$sessionResult = $Session.Initialize()
If ($sessionResult.HttpStatus -ne '200'){
    return $sessionResult
}
# End default session block
