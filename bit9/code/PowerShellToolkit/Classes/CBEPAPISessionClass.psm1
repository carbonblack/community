<#
    CB Protection API Tools for PowerShell v2.0
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

    # Parameters required: none
    # Returns: Object - The response code information from the test connection to the session
    # This method will save the session information needed to access the api
    # Check to make sure the config has been run
    # This will pull in the json with the encrypted values, decrypt, and create a session from them
    # It also clears up the memory from the decryption process
    [system.object] Initialize (){
        try{
            $apiConfigTemp = ConvertFrom-Json "$(get-content $(Join-Path $env:localappdata "CBConfig\CBEPApiConfig.json"))"
        }
        catch{
            return $null
        }

        # Decrypt strings
        $Marshal = [System.Runtime.InteropServices.Marshal]
        $BstrUrl = $Marshal::SecureStringToBSTR(($apiConfigTemp.url | ConvertTo-SecureString))
        $BstrKey = $Marshal::SecureStringToBSTR(($apiConfigTemp.key | ConvertTo-SecureString))
        $keyTemp = $Marshal::PtrToStringAuto($BstrKey)
        $urlTemp = $Marshal::PtrToStringAuto($BstrUrl)

        $this.apiHeader = @{}
        $this.apiHeader.Add("X-Auth-Token", $keyTemp)
        $this.apiUrl = "https://$urlTemp/api/bit9platform/v1"

        # Free encrypted variables from memory
        $Marshal::ZeroFreeBSTR($BstrUrl)
        $Marshal::ZeroFreeBSTR($BstrKey)

        # Test the session start
        $tempResponse = @{}
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
        return $tempResponse
        # Test the session end
    }

    # Parameters required:  $urlQueryPart - the query part of the API call based on the API documentation
    # Returns:              $responseObject - the object that is returned from the API GET call
    # This method will do a get query on the api
    [system.object] Get ([string]$urlQueryPart){
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
    [system.object] Post ([string]$urlQueryPart, [system.object]$jsonObject){
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

    # Parameters required:  $urlQueryPart - the query part of the API call based on the API documentation
    # Returns:              $responseObject - the object that is returned from the API POST call
    # This method will do a post query to the api
    [system.object] Put ([string]$urlQueryPart, [system.object]$jsonObject){
        $tempResponse = @{}
        try{
            $responseObject = Invoke-RestMethod -Headers $this.apiHeader -Method Put -Uri ($this.apiUrl + $urlQueryPart) -Body $jsonObject -ContentType 'application/json'
        }
        catch{
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription
            $tempResponse.Add("Message", "Problem with the PUT call")
            $tempResponse.Add("Query", $urlQueryPart)
            $tempResponse.Add("HttpStatus", $statusCode)
            $tempResponse.Add("HttpDescription", $statusDescription)
            $responseObject = $tempResponse
        }
        return $responseObject
    }
}