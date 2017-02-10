<#
    CB Protection API Tools for PowerShell v1.1
    Copyright (C) 2017 Thomas Brackin

    Requires: Powershell v5.1

    Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

    The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
#>

class CBEPPolicy{
    [system.object]$policy

    # Parameters required:  $policyId - Unique id of this policy
    #                       $session - this is a session object from the CBEPSession class
    # This method will use an open session to ask for a get query on the api
    [void] GetPolicy ([string]$policyId, [system.object]$session){
        $urlQueryPart = "/Policy?q=id:" + $policyId
        $tempPolicy = $session.getQuery($urlQueryPart)
        If ($this.policy){
            $i = 0
            While ($i -lt $this.policy.length){
                If ($this.policy[$i].id -eq $tempPolicy.id){
                    $this.policy[$i] = $tempPolicy
                    return
                }
                $i++
            }
        }
        $this.policy += $tempPolicy
    }
}