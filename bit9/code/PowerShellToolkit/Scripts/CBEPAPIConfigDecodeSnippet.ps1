# Check to make sure the config has been run
# This will pull in the json with the encrypted values, decrypt, and create a session from them
# It also clears up the memory from the decryption process
try{
    $apiConfig = ConvertFrom-Json "$(get-content $(Join-Path $env:temp "CBEPAPIConfig.json"))"

    $CBEPSession = [CBEPSession]::new()

    $Marshal = [System.Runtime.InteropServices.Marshal]
    $BstrUrl = $Marshal::SecureStringToBSTR(($apiConfig.url | ConvertTo-SecureString))
    $BstrKey = $Marshal::SecureStringToBSTR(($apiConfig.key | ConvertTo-SecureString))

    $CBEPSession.EnterSession($Marshal::PtrToStringAuto($BstrUrl), $Marshal::PtrToStringAuto($BstrKey))

    $Marshal::ZeroFreeBSTR($BstrUrl)
    $Marshal::ZeroFreeBSTR($BstrKey)
}
catch{
    "Please run the config tool first! .\Scripts\CBEPAPICreateConfigFile.ps1"
}