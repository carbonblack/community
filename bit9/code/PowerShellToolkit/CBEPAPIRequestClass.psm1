<#
    CB Protection API Tools for PowerShell v1.0
    Copyright (C) 2017 Thomas Brackin

    Requires: Powershell v5.1

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# This class is for creating a request object that can hold an array of requests from the api
# It also includes some methods to manipulate the requests
class CBEPRequest{
    [system.object]$requests

    # Parameters required:  $requestID - this is the ID of an approval request
    #                           OR
    #                       $unopened - this is a boolean, either $true or $false (false is default) that will return all unopened requests of status 1
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to ask for a get query on the api
    [void] GetRequest ([string]$requestID, [boolean]$unopened, [system.object]$session){
        if ($requestID){
            $urlQueryPart = "/approvalRequest?q=id:" + $requestID
            $tempRequest = $session.getQuery($urlQueryPart)
            If ($this.requests){
                $i = 1
                While ($i -le $this.requests.length){
                    If($this.requests[$i].id -eq $tempRequest.id){
                        $this.requests[$i] = $tempRequest
                        return
                    }
                    $i++
                }
            }
            $this.requests += $tempRequest
        }
        elseif ($unopened){
            $this.requests = $null
            $urlQueryPart = "/approvalRequest?q=status:1"
            $this.requests = $session.getQuery($urlQueryPart)
        }
    }

    # Parameters required:  $requestID - this is the ID of an approval request
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to update the request with a post call to the api
    [void] UpdateRequest ([string]$requestID, [system.object]$session){
        $urlQueryPart = "/approvalRequest/"
        If ($this.requests){
            $i = 1
            While ($i -le $this.requests.length){
                If ($this.requests[$i].id -eq $requestID){
                    $jsonObject = ConvertTo-Json -InputObject $this.requests[$i]
                    $this.requests[$i] = $session.postQuery($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }

    # Parameters required:  $requestID - this is the ID of an approval request
    # This method will modify the variable to mark a request as opened
    # You will still need to call the update method before this is applied to the api
    [void] OpenRequest ([string]$requestID){
        ($this.requests | Where-Object {$_.id -eq $requestID}).status = 2
    }

    # Parameters required:  $requestID - this is the ID of an approval request
    # This method will modify the variable to mark a request as closed
    # You will still need to call the update method before this is applied to the api
    [void] CloseRequest ([string]$requestID){
        ($this.requests | Where-Object {$_.id -eq $requestID}).status = 3
    }

    # Parameters required:  $requestID - this is the ID of an approval request
    # This method will modify the variable to mark a request as approved
    # You will still need to call the update method before this is applied to the api
    [void] GrantRequest([string]$requestID){
        ($this.requests | Where-Object {$_.id -eq $requestID}).resolution = 2
    }

    # Parameters required:  $requestID - this is the ID of an approval request
    # This method will modify the variable to mark a request as rejected
    # You will still need to call the update method before this is applied to the api
    [void] BlockRequest([string]$requestID){
        ($this.requests | Where-Object {$_.id -eq $requestID}).resolution = 1
    }
}
