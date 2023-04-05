# Define email parameters
$from = "sender@example.com"
$to = "recipient@example.com"
$subject = "Test Execution Report - Failed Tests"
$body = "The following tests have failed in the latest test execution: <br>"
# Retrieve failed tests and append to the email body

# Create a zip file of the folder to be attached
$folderPath = "C:\path\to\folder" # Update with the path to your folder
$zipPath = "C:\path\to\folder.zip" # Update with the desired path for the zip file
Compress-Archive -Path $folderPath -DestinationPath $zipPath

# Send email with folder attached
Send-MailMessage -From $from -To $to -Subject $subject -Body $body -BodyAsHtml -SmtpServer "smtp.example.com" -Attachments $zipPath


  - task: PowerShell@2
    displayName: 'Run PowerShell Script'
    inputs:
      targetType: 'filePath'
      filePath: 'path/to/send_email.ps1' 
      arguments: '-ExecutionPolicy Unrestricted'
      
      
  
 steps:
  - script: |
      # Define email parameters
      $from = "sender@example.com"
      $to = "recipient@example.com"
      $subject = "Test Execution Report - Failed Tests"
      $body = "The following tests have failed in the latest test execution: <br>"
      
      # Retrieve failed tests and append to the email body
      
      # Create a zip file of the folder to be attached
      $folderPath = "C:\path\to\folder" # Update with the path to your folder
      $zipPath = "C:\path\to\folder.zip" # Update with the desired path for the zip file
      Compress-Archive -Path $folderPath -DestinationPath $zipPath
      
      # Send email with folder attached
      Send-MailMessage -From $from -To $to -Subject $subject -Body $body -BodyAsHtml -SmtpServer "smtp.example.com" -Attachments $zipPath
    displayName: 'Execute PowerShell Script'
  - task: PowerShell@2
    inputs:
      targetType: 'filePath'
      filePath: '$(Agent.BuildDirectory)/path/to/your/powershell_script.ps1'
      arguments: '-ExecutionPolicy Unrestricted'
    displayName: 'Run PowerShell Script'
