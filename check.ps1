# Set input variables
$myorg = "my-ado-org"
$myproj = "my-ado-project"
$sendmailto = "devops.user1@xyz.com,devops.user2@xyz.com" # comma separated email ids of receivers
$mysubject = "my custom subject of the mail" # Subject of the email
$mailbody = "my custom mail body details" # mail body
$attachmentPath = "C:\path\to\folder\to\attach" # path to the folder to attach

# Get TFS IDs of users to send mail
$mailusers = "$sendmailto"
$mymailusers = $mailusers -split ","
$pat = "Bearer $env:System_AccessToken"
$myurl ="https://dev.azure.com/${myorg}/_apis/projects/${myproj}/teams?api-version=5.1"
$data = Invoke-RestMethod -Uri "$myurl" -Headers @{Authorization = $pat}
$myteams = $data.value.id

# Get list of members in all teams
$myusersarray = @()
foreach($myteam in $myteams) {
    $usrurl = "https://dev.azure.com/${myorg}/_apis/projects/${myproj}/teams/"+$myteam+"/members?api-version=5.1"
    $userdata = Invoke-RestMethod -Uri "$usrurl" -Headers @{Authorization = $pat}
    $myusers = $userdata.value
    foreach($myuser in $myusers) {
        $myuserid = $myuser.identity.id
        $myusermail = $myuser.identity.uniqueName
        $myuserrecord = "$myuserid"+":"+"$myusermail"
        $myusersarray += $myuserrecord
    }
}

# Filter unique users and create hash of emails and TFS IDs
$myfinalusersaray = $myusersarray | sort -Unique
$myusershash = @{}
for ($i = 0; $i -lt $myfinalusersaray.count; $i++)
{
    $myusershash[$myfinalusersaray[$i].split(":")[1]] = $myfinalusersaray[$i].split(":")[0]
}

# Create list of TFS IDs of mailers
$myto = @()
foreach($mymail in $mymailusers) {
    $myto += $myusershash[$mymail]
}

# Convert attachment to base64
$attachmentBytes = [System.IO.File]::ReadAllBytes($attachmentPath)
$base64String = [System.Convert]::ToBase64String($attachmentBytes)
$attachment = @{
    'fileName' = [System.IO.Path]::GetFileName($attachmentPath)
    'content' = $base64String
    'contentType' = 'application/octet-stream'
}

# Send email
$uri = "https://${myorg}.vsrm.visualstudio.com/${myproj}/_apis/Release/sendmail/$(RELEASE.RELEASEID)?api-version=3.2-preview.1"
$requestBody = @{
    "senderType"=1;
    "to"=@{"tfsIds"=$myto};
    "body"="$mailbody";
    "subject"="$mysubject";
    "attachments"=@($attachment)
} | ConvertTo-Json

try {
    Invoke-RestMethod -Uri $uri -Body $requestBody -Method POST -Headers @{Authorization = $pat} -ContentType "application/json"
}
catch {
    $_.Exception
}
