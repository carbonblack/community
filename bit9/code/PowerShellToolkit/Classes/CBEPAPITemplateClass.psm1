<#
    CB Protection API Tools for PowerShell v2.0
    Copyright (C) 2017 Thomas Brackin

    Requires: Powershell v5.1

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# This class is for creating a CBEP object that holds template information
# It also includes the methods needed to manipulate the data to send to the API
class CBEPTemplate{
    [system.object]$template

    # Parameters required:  $session - this is a session object from the CBEPSession class
    # Parameters optional:  $computerName - this is the computer name that you want to get information about
    #                       $computerId - the id of the computer
    # Returns: system.object - templates returned from the API
    # This method will use an open session to ask for a GET query on the api
    [void] Get ([string]$computerName, [string]$computerId, [system.object]$session){
        If ($computerName){
            $urlQueryPart = "/Computer?q=name:" + $computerName + "&q=deleted:false&q=template:true"
        }
        ElseIf ($computerId){
            $urlQueryPart = "/Computer?q=id:" + $computerId + "&q=deleted:false&q=template:true"
        }
        Else{
            return
        }
        $tempTemplate = $session.get($urlQueryPart)
        If ($this.template){
            $i = 0
            While ($i -lt $this.template.length){
                If ($this.template[$i].id -eq $tempTemplate.id){
                    $this.template[$i] = $tempTemplate
                    Return
                }
                $i++
            }
        }
        $this.template += $tempTemplate
    }

    # Parameters required:  $computerID - this is the ID of a computer
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to turn off tamper protection with a PUT call to the api
    [void] Delete ([string]$computerID, [system.object]$session){
        If ($this.template){
            $urlQueryPart = "/Computer/" + $computerID + "?delete=true"
            $i = 0
            While ($i -lt $this.template.length){
                If ($this.template[$i].id -eq $computerID){
                    $jsonObject = ConvertTo-Json -InputObject $this.template[$i]
                    $this.template[$i] = $session.put($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }
}