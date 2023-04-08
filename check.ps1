$OrganizationName = "organization"
$ProjectName = "project"
$sendmailto = "xxx@microsoft.com"
$mysubject = "Test Mail Subjcet"

$HeaderMail = @{
    Authorization = "Bearer $env:SYSTEM_ACCESSTOKEN"
}
 
#Get the tfsid

$userentitlementurl = "https://vsaex.dev.azure.com/${OrganizationName}/_apis/userentitlements?api-version=7.1-preview.1"

$response = Invoke-RestMethod -Uri $userentitlementurl -Method Get -Headers $HeaderMail

#Filter by sendmailto
$tfsid = ($response.value| where {$_.user.mailAddress -eq $sendmailto}).id

Write-Host $tfsid

##send mail
$urimail = "$env:SYSTEM_TEAMFOUNDATIONSERVERURI$env:SYSTEM_TEAMPROJECT/_apis/Release/sendmail/$($env:RELEASE_RELEASEID)?api-version=7.1-preview.1"

$requestBody =
@"
{
    "senderType": 1,
    "to": {
        "tfsIds": [
            "$tfsid"
        ],
        "emailAddresses": []
    },
    "subject": "$mysubject",
    "sections": [
        5,
        0,
        1,
        2,
        4
    ]
}
"@
Try {
Invoke-RestMethod -Uri $urimail -Body $requestBody -Method POST -ContentType "application/json" -Headers $HeaderMail
}
Catch {
$_.Exception
}
