# Define variables
$emailSubject = "Test"
$emailBody = "checking"

$senderEmail = "EDGE-RBA@aib.ie"
$recipientEmails = "kandan.x.munusamy@aib.ie", "abdulvahap.x.n@aib.ie", "EDGE_Wintel@aib.ie"
$smtpServer = "smtp-ngwi-01.aib.pri"
$reportPath = ""

# Send email with report attachment
try {
    $message = New-Object System.Net.Mail.MailMessage
    $message.From = $senderEmail
    foreach ($recipient in $recipientEmails) {
        $message.To.Add($recipient)
    }
    $message.Subject = $emailSubject
    $message.Body = $emailBody
    $message.IsBodyHtml = $true

    $attachment = New-Object System.Net.Mail.Attachment($reportPath)
    $message.Attachments.Add($attachment)

    $smtp = New-Object System.Net.Mail.SmtpClient($smtpServer)
    $smtp.DeliveryMethod = [System.Net.Mail.SmtpDeliveryMethod]::Network
    $smtp.Send($message)

    Write-Output "Email sent successfully to $($recipientEmails -join ', ')"
}
catch {
    Write-Error "Failed to send email: $($_.Exception.Message)"
}
finally {
    if ($attachment) {
        $attachment.Dispose()
    }
    if ($message) {
        $message.Dispose()
    }
}
