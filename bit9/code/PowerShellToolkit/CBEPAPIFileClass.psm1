<#
    CB Protection API Tools for PowerShell v1.0
    Copyright (C) 2017 Thomas Brackin

    Requires: Powershell v5.1

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

# This class is for creating a file object that can hold both local and global file information
# It also includes methods for manipulating this information
class CBEPFile{
    [system.object]$fileCatalog
    [system.object]$fileInstance

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to ask for a get query on the api
    [void] GetFileCatalog ([string]$fileCatalogId, [system.object]$session){
        $urlQueryPart = "/fileCatalog?q=id:" + $fileCatalogId
        $tempFile = $session.getQuery($urlQueryPart)
        If ($this.fileCatalog){
            $i = 1
            While ($i -le $this.fileCatalog.length){
                If ($this.fileCatalog[$i].id -eq $tempFile.id){
                    $this.fileCatalog[$i] = $tempFile
                    return
                }
                $i++
            }
        }
        $this.fileCatalog += $tempFile
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    #                       $computerId - this is the ID of a computer that the file is on
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to ask for a get query on the api
    [void] GetFileInstance ([string]$fileCatalogId, [string]$computerId, [system.object]$session){
        $urlQueryPart = "/fileInstance?q=fileCatalogId:" + $fileCatalogId + "&q=computerId:" + $computerId
        $tempFile = $session.getQuery($urlQueryPart)
        If ($this.fileInstance){
            $i = 1
            While ($i -le $this.fileInstance.length){
                If ($this.fileInstance[$i].id -eq $tempFile.id){
                    $this.fileInstance[$i] = $tempFile
                    return
                }
                $i++
            }
        }
        $this.fileInstance += $tempFile
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    #                       $computerId - this is the ID of a computer that the file is on
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to update the request with a post call to the api
    [void] UpdateFileLocal ([string]$fileInstanceId, [system.object]$session){
        If ($this.fileInstance){
            $urlQueryPart = "/fileInstance?q=id:" + $fileInstanceId
            $i = 1
            While ($i -le $this.fileInstance.length){
                If ($this.fileInstance[$i].id -eq $fileInstanceId){
                    $jsonObject = ConvertTo-Json -InputObject $this.fileInstance[$i]
                    $this.fileInstance[$i] = $session.postQuery($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to update the request with a post call to the api
    [void] UpdateFileGlobal ([string]$fileCatalogId, [system.object]$session){
        If ($this.fileCatalog){
            $urlQueryPart = "/fileCatalog?q=id:" + $fileCatalogId
            $i = 1
            While ($i -le $this.fileCatalog.length){
                If ($this.fileCatalog[$i].id -eq $fileCatalogId){
                    $jsonObject = ConvertTo-Json -InputObject $this.fileCatalog[$i]
                    $this.fileCatalog[$i] = $session.postQuery($urlQueryPart, $jsonObject)
                }
                $i++
            }
        }
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    #                       $computerId - this is the ID of a computer that the file is on
    # This method will modify the variable to mark a local file as approved
    # You will still need to call the update method before this is applied to the api
    [void] GrantFileLocal ([string]$fileInstanceId){
        ($this.fileInstance | Where-Object {$_.id -eq $fileInstanceId}).localState = 2
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    #                       $computerId - this is the ID of a computer that the file is on
    # This method will modify the variable to mark a local file as unapproved
    # You will still need to call the update method before this is applied to the api
    [void] RevokeFileLocal ([string]$fileInstanceId){
        ($this.fileInstance | Where-Object {$_.id -eq $fileInstanceId}).localState = 1
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    #                       $computerId - this is the ID of a computer that the file is on
    # This method will modify the variable to mark a local file as banned
    # You will still need to call the update method before this is applied to the api
    [void] BlockFileLocal ([string]$fileInstanceId){
        ($this.fileInstance | Where-Object {$_.id -eq $fileInstanceId}).localState = 3
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    # This method will modify the variable to mark a global file as approved
    # You will still need to call the update method before this is applied to the api
    [void] GrantFileGlobal ([string]$fileCatalogId){
        ($this.fileCatalog | Where-Object {$_.id -eq $fileCatalogId}).fileState = 2
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    # This method will modify the variable to mark a global file as unapproved
    # You will still need to call the update method before this is applied to the api
    [void] RevokeFileGlobal ([string]$fileCatalogId){
        ($this.fileCatalog | Where-Object {$_.id -eq $fileCatalogId}).fileState = 1
    }

    # Parameters required:  $fileCatalogId - this is the ID of a file in the catalog
    # This method will modify the variable to mark a global file as banned
    # You will still need to call the update method before this is applied to the api
    [void] BlockFileGlobal ([string]$fileCatalogId){
        ($this.fileCatalog | Where-Object {$_.id -eq $fileCatalogId}).fileState = 3
    }
}
