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
class VTAnalysis{
    [string]$apiKey

    [boolean] Initialize (){
        try{
            $apiConfigTemp = ConvertFrom-Json "$(get-content $(Join-Path $env:localappdata "CBConfig\CBEPApiConfig.json"))"
        }
        catch{
            return $false
        }

        If ($apiConfigTemp.vtkey){
            # Decrypt strings
            $Marshal = [System.Runtime.InteropServices.Marshal]
            $BstrKey = $Marshal::SecureStringToBSTR(($apiConfigTemp.vtkey | ConvertTo-SecureString))
            $this.apiKey = $Marshal::PtrToStringAuto($BstrKey)

            # Free encrypted variables from memory
            $Marshal::ZeroFreeBSTR($BstrKey)
            return $true
        }
        Else{
            return $false
        }
    }
    # Parameters required: none
    # Returns: Object - The response code information from the test connection to the session
    # This method will save the session information needed to access the api
    # Check to make sure the config has been run
    # This will pull in the json with the encrypted values, decrypt, and create a session from them
    # It also clears up the memory from the decryption process
    [string] GetHash ([System.IO.FileInfo] $file){
        $hashType = 'sha256'
        $stream = $null
        $result = $null
        $hashAlgorithm = [System.Security.Cryptography.HashAlgorithm]::Create($hashType)
        $stream = $file.OpenRead()
        $hashByteArray = $hashAlgorithm.ComputeHash($stream)
        $stream.Close()

        trap{
            if ($stream -ne $null){
                $stream.Close();
            }
            return $null
        }

        # Convert the hash to Hex
        $hashByteArray | ForEach-Object{
            $result += $_.ToString("X2")
        }
        return $result
    }

    # Parameters required: none
    # Parameters optional: $file - a file
    #                      $hash - a hash of a file
    [system.object] GetReport ([System.IO.FileInfo]$file, [String]$hash) {
        If ($file){
            $hash = $this.GetHash($file)
        }

        $body = @{
                resource = $hash;
                apikey = $this.apiKey
            }

        $tempResponse = @{}
        try{
            $responseObject = Invoke-RestMethod -Method POST -Uri 'https://www.virustotal.com/vtapi/v2/file/report' -Body $body
        }
        catch{
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription
            $tempResponse.Add("Message", "Problem with the POST call")
            $tempResponse.Add("Query", $body)
            $tempResponse.Add("HttpStatus", $statusCode)
            $tempResponse.Add("HttpDescription", $statusDescription)
            $responseObject = $tempResponse
        }
        return $responseObject
    }

    [system.text.encoding] GetBytes([String] $str) {
        $bytes = New-Object Byte[] ($str.Length * 2)
        $bytes = [System.Text.Encoding]::ASCII.GetBytes($str)
        return $bytes
    }

    [system.object] InvokeScan ([System.IO.FileInfo] $file){

        If (!(Test-Path $file -pathtype Leaf)){
            return $null
        }

        [byte[]]$CRLF = 13, 10
        $body = New-Object System.IO.MemoryStream

        $boundary = [Guid]::NewGuid().ToString().Replace('-','')
        $ContentType = 'multipart/form-data; boundary=' + $boundary
        $b2 = $this.GetBytes('--' + $boundary)
        $body.Write($b2, 0, $b2.Length)
        $body.Write($CRLF, 0, $CRLF.Length)
        
        $b = ($this.GetBytes('Content-Disposition: form-data; name="apikey"'))
        $body.Write($b, 0, $b.Length)

        $body.Write($CRLF, 0, $CRLF.Length)
        $body.Write($CRLF, 0, $CRLF.Length)
        
        $b = ($this.GetBytes($this.apiKey))
        $body.Write($b, 0, $b.Length)

        $body.Write($CRLF, 0, $CRLF.Length)
        $body.Write($b2, 0, $b2.Length)
        $body.Write($CRLF, 0, $CRLF.Length)
        
        $b = ($this.GetBytes('Content-Disposition: form-data; name="file"; filename="' + $file.Name + '";'))
        $body.Write($b, 0, $b.Length)
        $body.Write($CRLF, 0, $CRLF.Length)            
        $b = ($this.GetBytes('Content-Type:application/octet-stream'))
        $body.Write($b, 0, $b.Length)
        
        $body.Write($CRLF, 0, $CRLF.Length)
        $body.Write($CRLF, 0, $CRLF.Length)
        
        $b = [System.IO.File]::ReadAllBytes($file.FullName)
        $body.Write($b, 0, $b.Length)

        $body.Write($CRLF, 0, $CRLF.Length)
        $body.Write($b2, 0, $b2.Length)
        
        $b = ($this.GetBytes('--'))
        $body.Write($b, 0, $b.Length)
        
        $body.Write($CRLF, 0, $CRLF.Length)

        $tempResponse = @{}
        try{
            $responseObject = Invoke-RestMethod -Method POST -Uri 'https://www.virustotal.com/vtapi/v2/file/scan' -ContentType $ContentType -Body $body.ToArray()
        }
        catch{
            $statusCode = $_.Exception.Response.StatusCode.value__
            $statusDescription = $_.Exception.Response.StatusDescription
            $tempResponse.Add("Message", "Problem with the POST call")
            $tempResponse.Add("Query", $body)
            $tempResponse.Add("HttpStatus", $statusCode)
            $tempResponse.Add("HttpDescription", $statusDescription)
            $responseObject = $tempResponse
        }
        return $responseObject
    }
}
