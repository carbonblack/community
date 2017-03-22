<#
        .SYNOPSIS
        This script is inteded to be ran after a CB Protection server update to copy the installers to a separate web server
        .DESCRIPTION
        For this script, it is assumed you have an architecture where the CB Protection server is only accessible by the agents on the default communication port.
        In this scenario, 443 access is blocked from the outside to protect the console from outside access. Due to this, an external webserver is needed to host the
        update files to allow the agents to still update normally after the server version has updated. For more information on this architecture, please consult the
        CB Protection document 'Cb Protection - Always-Connected Agents.pdf'.
        .NOTES
        CB Protection API Tools for PowerShell v1.1
        Copyright (C) 2017 Thomas Brackin

        Requires: Powershell v5.1

        Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# EDIT THIS SECTION WITH YOUR SERVER INFO
# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Name of CBEP DMZ server
$cbepdmzserver = "YOUR_SERVER_HERE"
# Name of DMZ web server
$webserver = "YOUR_WEBSERVER_HERE"
# Web address to the DMZ web server
$hosturi = "https://YOUR_URL_HERE"
# Path on DMZ web server
$destinationPath = "\\$webserver\d$\CBEP Agents\"

# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX
# DO NOT EDIT THE BELOW VARIABLES
# XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX

# Old URI for ServerIP
$serveripuri = "https://**ServerIP**/hostpkg/pkg.php?pkg=/"
# XML file and backup paths
$XMLFile = "\\$cbepdmzserver\D$\Program Files (x86)\Bit9\Parity Server\upgrade\upgrade.xml"
$XMLBackup = "\\$cbepdmzserver\D$\Program Files (x86)\Bit9\Parity Server\upgrade\upgradebackup.xml"
# Paths to CBEP DMZ server files
$macAgentPathSource = "\\$cbepdmzserver\d$\Program Files (x86)\Bit9\Parity Server\hostpkg\Bit9MacInstall.bsx"
$windowsHostAgentPathSource = "\\$cbepdmzserver\d$\Program Files (x86)\Bit9\Parity Server\hostpkg\ParityHostAgent.msi"

# Copy the installers to the new destinations
Copy-Item -Path $macAgentPathSource -Destination $destinationPath
Copy-Item -Path $windowsHostAgentPathSource -Destination $destinationPath

# Get the CBEP server service
$CBEPService = get-service -computername $cbepdmzserver | Where-Object {$_.name -eq "ParityServer"}

# Stop the CBEP server service
Stop-Service -inputobject $CBEPService

# Make a backup of the xml
Copy-Item $XMLFile $XMLBackup

# Load XML file
$XMLDocument = New-Object XML
$XmlDocument.Load($XMLFile)

# Select just the nodes that we want
$nodes = $XMLDocument.SelectNodes("/upgradelist/version")

# Set the new attributes
Foreach ($node in $nodes){
    $node.SetAttribute("uri",(($node.uri -replace [Regex]::Escape($serveripuri),[Regex]::Escape($hosturi)) -replace "\\",""))
}

# Save the XML
$XmlDocument.Save($XMLFile)

# Start CBEP server service
Start-Service -inputobject $CBEPService