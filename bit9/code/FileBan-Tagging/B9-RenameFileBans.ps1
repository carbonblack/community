$apiKey = "Your API Token Here"
$URLResource = "https://serverURL/api/bit9platform/v1/fileRule"

$URLfileBan = $URLResource+"?q=fileState:3"

$FileBan = Invoke-RestMethod -Uri $URLfileBan -Method Get -Header @{ "X-Auth-Token" = $apiKey } 

foreach ( $ban in $FileBan )
{
    $ConsoleUsers = $ban.createdBy
    $RuleName = $ban.name
    switch ($ConsoleUsers) 
    { 
        "User1" { $TeamTag = "[Team1]" } 
        "User2" { $TeamTag = "[Team2]" } 
        "User3" { $TeamTag = "[Team3]" } 
        "User4" { $TeamTag = "[Team1]" } 
        "User5" { $TeamTag = "[Team1]" } 
        "System" { $TeamTag = "[System]" } 
        default {"Could not determine"}
    }
    if ( $RuleName -notmatch "$TeamTag*" ) 
        {
            $ban.name = $TeamTag + $RuleName
            $json = $ban | ConvertTo-Json
            $URLfileBan = $URLResource
            Invoke-RestMethod -Uri $URLfileBan -Method Post -Header @{ "X-Auth-Token" = $apiKey }  -Body $json -ContentType 'application/json'
        }
}
