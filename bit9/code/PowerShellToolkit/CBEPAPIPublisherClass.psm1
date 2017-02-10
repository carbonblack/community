<#
    CB Protection API Tools for PowerShell v1.1
    Copyright (C) 2017 Thomas Brackin

    Requires: Powershell v5.1

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# This class is for creating a CBEP object that holds publisher information
# It also inclues the methods needed to manipulate the data to send to the API
class CBEPPublisher{
    [system.object]$publisher
    
    # Parameters required:  $publisherId - Unique id of this publisher
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to ask for a get query on the api
    [void] GetPublisher ([string]$publisherId, [system.object]$session){
        $urlQueryPart = "/Publisher?q=id:" + $publisherId
        $tempPublisher = $session.getQuery($urlQueryPart)
        If ($this.publisher){
            $i = 0
            While ($i -lt $this.publisher.length){
                If ($this.publisher[$i].id -eq $tempPublisher.id){
                    $this.publisher[$i] = $tempPublisher
                    return
                }
                $i++
            }
        }
        $this.publisher += $tempPublisher
    }
}