# Set the version of ChromeDriver to download
$chromeDriverVersion = "94.0.4606.61"

# Set the URL of the ChromeDriver binary for Windows
$chromeDriverUrl = "https://chromedriver.storage.googleapis.com/$chromeDriverVersion/chromedriver_win32.zip"

# Download the ChromeDriver binary
Invoke-WebRequest -Uri $chromeDriverUrl -OutFile "$($env:AGENT_TOOLSDIRECTORY)\chromedriver.zip"

# Extract the binary to the tools directory
Expand-Archive "$($env:AGENT_TOOLSDIRECTORY)\chromedriver.zip" -DestinationPath "$($env:AGENT_TOOLSDIRECTORY)\chromedriver"

# Add the tools directory to the system PATH
$env:PATH += ";$($env:AGENT_TOOLSDIRECTORY)\chromedriver"


# Set the URL of the Google Chrome installer
$chromeInstallerUrl = "https://dl.google.com/chrome/install/standalone/GoogleChromeStandaloneEnterprise64.msi"

# Set the file path to save the installer
$chromeInstallerPath = "$($env:AGENT_TEMPDIRECTORY)\GoogleChromeStandaloneEnterprise64.msi"

# Download the Chrome installer
Invoke-WebRequest -Uri $chromeInstallerUrl -OutFile $chromeInstallerPath

# Install Chrome silently
Start-Process -FilePath msiexec.exe -ArgumentList "/i `"$chromeInstallerPath`" /qn" -Wait
