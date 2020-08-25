# Authenticate on CR
$Url = "http://doctorstrange/v1/authentication"
$Body = ConvertTo-Json @{
  #Username and password which have access to the locker
  username = "testuser"
    password = "testpassword"
 }
$response = Invoke-RestMethod -Method Post -ContentType application/json -Uri $Url -Body $Body

# Get Credential ID for the PC
$Uri = "http://doctorstrange/v2/credentialvault/credentials?name=$env:computername"
$kill = @{
Headers = @{'X-Authorization'= $response.token}
Method = 'Get'
ContentType = 'application/json'
}

#Get credentials attributes into variable
$getcredid = Invoke-RestMethod -Uri $Uri @kill
$credid = $getcredid.list[0].id
$Uri = "http://doctorstrange/v2/credentialvault/credentials/$credid/attributevalues"
$clientcreds = @{
Headers = @{'X-Authorization'= $response.token}
Method = 'Get'
ContentType = 'application/json'
}
$clientcredentials = Invoke-RestMethod -Uri $Uri @clientcreds
$username = $clientcredentials.list[0].value
$password = $clientcredentials.list[1].value

#Login to AA using credentials attribute
& "C:\Program Files (x86)\Automation Anywhere\Enterprise\Client\Automation Anywhere.exe" "/u$username" "/p$password" "/aopen" "/llogin"
