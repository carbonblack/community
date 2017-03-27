using module ..\Classes\CBEPAPIComputerClass.psm1
using module ..\Classes\CBEPAPITemplateClass.psm1
using module ..\Classes\CBEPAPISessionClass.psm1

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
    [Parameter(
        Mandatory=$true,
        ValueFromPipeline=$true
    )]
    [string[]]$computerName
)
# Change this value (in seconds) if you want to wait longer for the computer to show disconnected
[system.int32]$timeout = 1

# Start default session block
# Create a session and make sure it works
$Session = [CBEPSession]::new()
$sessionResult = $Session.Initialize()
If ($sessionResult.HttpStatus -ne '200'){
    return $sessionResult
}
# End default session block

$timespan = New-TimeSpan -Minutes $timeout
$Computer = [CBEPComputer]::new()
$Template = [CBEPTemplate]::new()

$Computer.Get($computerName, "", $session)

If ($Computer.computer.length -gt 1){
    Write-Error -Message ("Multiple computers with the same name detected. Please remediate and try again.")
    Return
}

# While the computer is connected or not fully synced, or we have not hit our timeout, update our information about it
$stopWatch = [Diagnostics.Stopwatch]::StartNew()
While ($stopWatch.ElapsedMilliseconds -lt $timespan.TotalMilliseconds){
    If (!($Computer.computer.connected -eq "True")){
        Break
    }
    Start-Sleep -Seconds 25
    $Computer.Get("", $Computer.computer.Id, $session)
}

If ($Computer.computer.connected -eq "True"){
    Write-Error -Message ("Target computer is still connected.")
    Return
}
If ($Computer.computer.syncPercent -lt '100'){
    Write-Error -Message ("Target computer is not fully syncronized.")
    Return
}

$Template.Get("", $Computer.computer.templateComputerId, $session)
$Template.Delete($Template.template.Id, $session)
$Computer.Convert($Computer.computer.Id, $session)
$Template.Get("", $Computer.computer.Id, $session)

$Template.template