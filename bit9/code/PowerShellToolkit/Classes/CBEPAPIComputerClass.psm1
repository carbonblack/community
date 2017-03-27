<#
    CB Protection API Tools for PowerShell v2.0
    Copyright (C) 2017 Thomas Brackin

    Requires: Powershell v5.1

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# This class is for creating a CBEP object that holds computer information
# It also includes the methods needed to manipulate the data to send to the API
class CBEPComputer{
    [system.object]$computer

    # Parameters required:  $computerName - this is the computer name that you want to get information about
    #                       $session - this is a session object from the CBEPSession class
    # Returns: system.object - computers returned from the API
    # This method will use an open session to ask for a GET query on the api
    [void] Get ([string]$computerName, [string]$computerId, [system.object]$session){
        If ($computerName){
            $urlQueryPart = "/Computer?q=name:" + $computerName + "&q=deleted:false&q=template:false"
        }
        ElseIf ($computerId){
            $urlQueryPart = "/Computer?q=id:" + $computerId + "&q=deleted:false&q=template:false"
        }
        Else{
            return
        }
        $tempComputer = $session.get($urlQueryPart)
        If ($this.computer){
            $i = 0
            While ($i -lt $this.computer.length){
                If ($this.computer[$i].id -eq $tempComputer.id){
                    $this.computer[$i] = $tempComputer
                    Return
                }
                $i++
            }
        }
        $this.computer += $tempComputer
    }

    # Parameters required:  $computerID - this is the ID of a computer
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to update the request with a POST call to the api
    [void] Update ([string]$computerID, [system.object]$session){
        If ($this.computer){
            $urlQueryPart = "/Computer?q=id:" + $computerID
            $i = 0
            While ($i -lt $this.computer.length){
                If ($this.computer[$i].id -eq $computerID){
                    $jsonObject = ConvertTo-Json -InputObject $this.computer[$i]
                    $this.computer[$i] = $session.post($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }

    # Parameters required:  $computerID - this is the ID of a computer
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to turn off tamper protection with a PUT call to the api
    [void] Delete ([string]$computerID, [system.object]$session){
        If ($this.computer){
            $urlQueryPart = "/Computer/" + $computerID + "?delete=true"
            $i = 0
            While ($i -lt $this.computer.length){
                If ($this.computer[$i].id -eq $computerID){
                    $jsonObject = ConvertTo-Json -InputObject $this.computer[$i]
                    $this.computer[$i] = $session.put($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }
    # Parameters required:  $computerID - this is the ID of a computer
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to update the request with a PUT for the conversion to a template
    [void] Convert ([string]$computerID, [system.object]$session){
        If ($this.computer){
            $urlQueryPart = "/Computer/" + $computerId + "?changeTemplate=true"
            $i = 0
            While ($i -lt $this.computer.length){
                If ($this.computer[$i].id -eq $computerID){
                    $this.computer[$i].template = "true"
                    $this.computer[$i].templateCloneCleanupMode = "1"
                    $this.computer[$i].templateTrackModsOnly = "true"
                    $jsonObject = ConvertTo-Json -InputObject $this.computer[$i]
                    $session.put($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }

    # Parameters required:  $computerID - this is the ID of a computer
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to turn on tamper protection with a PUT call to the api
    [void] EnableTamperProtection ([string]$computerID, [system.object]$session){
        If ($this.computer){
            $urlQueryPart = "/Computer/" + $computerID + "?newTamperProtectionActive=true"
            $i = 0
            While ($i -lt $this.computer.length){
                If ($this.computer[$i].id -eq $computerID){
                    $jsonObject = ConvertTo-Json -InputObject $this.computer[$i]
                    $this.computer[$i] = $session.put($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }

    # Parameters required:  $computerID - this is the ID of a computer
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to turn off tamper protection with a PUT call to the api
    [void] DisableTamperProtection ([string]$computerID, [system.object]$session){
        If ($this.computer){
            $urlQueryPart = "/Computer/" + $computerID + "?newTamperProtectionActive=false"
            $i = 0
            While ($i -lt $this.computer.length){
                If ($this.computer[$i].id -eq $computerID){
                    $jsonObject = ConvertTo-Json -InputObject $this.computer[$i]
                    $this.computer[$i] = $session.put($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }
}