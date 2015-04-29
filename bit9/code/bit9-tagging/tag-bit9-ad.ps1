$apiKey = "Your API Key Here"
$URLResource = "https://serverURL/api/bit9platform/v1/computer"
$ActiveComputers = $URLResource+"?q=deleted:false"

$Computers = Invoke-RestMethod -Uri $ActiveComputers -Method Get -Header @{ "X-Auth-Token" = $apiKey } 

foreach ( $Computer in $Computers )
{
    
    $LastUser = ($Computer.users).Split("\")[-1]
    if ($LastUser -ne $null)
    {
        Get-ADInfo
        if ($UserType -eq "C") {$Computer.computerTag = "{HVT}" + $LastUser}
        else {$Computer.computerTag = $LastUser}
        $Computer.description = $UserTitle
    }
    $json = $Computer | ConvertTo-Json
    Invoke-RestMethod -Uri $URLResource -Method Post -Header @{ "X-Auth-Token" = $apiKey } -Body $json -ContentType 'application/json'
}

function Get-ADInfo
{
    $info = Get-ADUser $LastUser -Properties employeeType,department,title
    Set-Variable -Name UserType -Value $info.employeeType -Scope Script
    Set-Variable -Name UserDept -Value $info.department -Scope Script
    Set-Variable -Name UserTitle -Value $info.title -Scope Script
}
