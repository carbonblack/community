<#
    CB Protection API Tools for PowerShell v1.1
    Copyright (C) 2017 Thomas Brackin

    Requires: Powershell v5.1

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# This class is for creating a session object that holds the relevant session data for the api connection
# It also includes the methods for a GET and PUSH on the Restful API call
class CBEPSession{
    [system.object]$apiHeader
    [string]$apiUrl

    # Parameters required: $serverUrl - the URL to your CB Protection server
    #                      $key - the API key that will be used for the session
    # This method will save the session information needed to access the api
    [void] EnterSession ([string]$url, [string]$key){
        $this.apiHeader = @{}
        $this.apiHeader.Add("X-Auth-Token", $key)
        $this.apiUrl = "https://$url/api/bit9platform/v1"
    }

    # Parameters required: None
    # This method will not give back errors for unresolvable URLs, only for bad URL paths
    [system.object] TestSession (){
        $tempResponse = @{}
        If ($this.apiUrl){
            try{
                $tempRequest = Invoke-WebRequest $this.apiUrl
                $tempResponse.Add("Message", "Test successful")
                $tempResponse.Add("HttpStatus", $tempRequest.StatusCode)
                $tempResponse.Add("HttpDescription", $tempRequest.StatusDescription)
            }
            catch{
                $statusCode = $_.Exception.Response.StatusCode.value__
                $statusDescription = $_.Exception.Response.StatusDescription
                $tempResponse.Add("Message", "Test failed")
                $tempResponse.Add("HttpStatus", $statusCode)
                $tempResponse.Add("HttpDescription", $statusDescription)
            }
        }
        return $tempResponse
    }

    # Parameters required:  $urlQueryPart - the query part of the API call based on the API documentation
    # Returns:              $responseObject - the object that is returned from the API GET call
    # This method will do a get query on the api
    [system.object] GetQuery ([string]$urlQueryPart){
        $tempResponse = @{}
        try{
            $responseObject = Invoke-RestMethod -Headers $this.apiHeader -Method Get -Uri ($this.apiUrl + $urlQueryPart)
        }
        catch{
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription
            $tempResponse.Add("Message", "Problem with the GET call")
            $tempResponse.Add("Query", $urlQueryPart)
            $tempResponse.Add("HttpStatus", $statusCode)
            $tempResponse.Add("HttpDescription", $statusDescription)
            $responseObject = $tempResponse
        }
        return $responseObject
    }

    # Parameters required:  $urlQueryPart - the query part of the API call based on the API documentation
    # Returns:              $responseObject - the object that is returned from the API POST call
    # This method will do a post query to the api
    [system.object] PostQuery ([string]$urlQueryPart, [system.object]$jsonObject){
        $tempResponse = @{}
        try{
            $responseObject = Invoke-RestMethod -Headers $this.apiHeader -Method Post -Uri ($this.apiUrl + $urlQueryPart) -Body $jsonObject -ContentType 'application/json'
        }
        catch{
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription
            $tempResponse.Add("Message", "Problem with the POST call")
            $tempResponse.Add("Query", $urlQueryPart)
            $tempResponse.Add("HttpStatus", $statusCode)
            $tempResponse.Add("HttpDescription", $statusDescription)
            $responseObject = $tempResponse
        }
        return $responseObject
    }
}