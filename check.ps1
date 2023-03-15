# Set the version of ChromeDriver to download
$chromeDriverVersion = "111.0.5563.64"

# Set the URL of the ChromeDriver binary for Windows
$chromeDriverUrl = "https://chromedriver.storage.googleapis.com/$chromeDriverVersion/chromedriver_win32.zip"

# Download the ChromeDriver binary
Invoke-WebRequest -Uri $chromeDriverUrl -OutFile "$($env:AGENT_TOOLSDIRECTORY)\chromedriver.zip"

# Extract the binary to the tools directory
Expand-Archive "$($env:AGENT_TOOLSDIRECTORY)\chromedriver.zip" -DestinationPath "$($env:AGENT_TOOLSDIRECTORY)\chromedriver"

# Add the tools directory to the system PATH
$env:PATH += ";$($env:AGENT_TOOLSDIRECTORY)\chromedriver"


	$Path = $env:TEMP;
	$Installer = "chrome_installer.exe"
	Invoke-WebRequest "http://dl.google.com/chrome/install/latest/chrome_installer.exe" -OutFile $Path\$Installer
	Start-Process -FilePath $Path\$Installer -Args "/silent /install" -Verb RunAs
	Remove-Item $Path\$Installer
