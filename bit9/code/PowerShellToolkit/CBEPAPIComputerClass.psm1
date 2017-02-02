<#
    CB Protection API Tools for PowerShell v1.0
    Copyright (C) 2017 Thomas Brackin

    Requires: Powershell v5.1

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# This class is for creating a CBEP object that holds computer information
# If also includes the methods needed to manipulate the data to send to the API
class CBEPComputer{
    [system.object]$computers

    # Parameters required:  $computerName - this is the computer name that you want to get information about
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to ask for a get query on the api
    [void] GetComputer ([string]$computerName, [system.object]$session){
        $urlQueryPart = "/Computer?q=name:*" + $computerName + "*&q=deleted:false"
        $tempComputer = $session.getQuery($urlQueryPart)
        If ($this.computers){
            $i = 1
            While ($i -le $this.computers.length){
                If ($this.computers[$i].id -eq $tempComputer.id){
                    $this.computers[$i] = $tempComputer
                    return
                }
                $i++
            }
        }
        $this.computers += $tempComputer
    }

    # Parameters required:  $computerID - this is the ID of a computer
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to update the request with a post call to the api
    [void] UpdateComputer ([string]$computerID, [system.object]$session){
        If ($this.computers){
            $urlQueryPart = "/Computer?q=id" + $computerID
            $i = 1
            While ($i -le $this.computers.length){
                If ($this.computers[$i].id -eq $computerID){
                    $jsonObject = ConvertTo-Json -InputObject $this.computers[$i]
                    $this.computers[$i] = $session.postQuery($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }
}
