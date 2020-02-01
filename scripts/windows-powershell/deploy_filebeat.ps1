# Deploy Filebeat powershell script - works for v6.x versions only
# Uses the SC CREATE command line with PSEXEC to deploy and create the services.
# Filebeat must be copied to the node locally in order for this to work.
# Execute this script to deploy the Filebeat agent. Must use an account with admin rights to run this script.

$computer = "my-hostname"

$command = 'sc create filebeat binPath= "C:\elastic\filebeat\filebeat.exe -c C:\elastic\filebeat\filebeat.yml -path.home C:\elastic\filebeat\ -path.data C:\elastic\filebeat -path.logs C:\elastic\filebeat" start= auto'

# Stop the filebeat service
C:\Windows\System32\PSExec.exe \\$computer net stop filebeat

# Make backup directory
mkdir \\$computer\c$\elastic\filebeat.backup

# Copy the registry file if it exists
$PSExec \\$computer cmd /c "copy c:\elastic\filebeat\registry c:\elastic\filebeat.backup\registry"

# Delete the Filebeat service
$PSExec \\$computer sc delete filebeat

# Delete old files if they exist
$PSExec \\$computer cmd /c "rmdir /s /q c:\elastic\filebeat"

# Recreate Filebeat directory
mkdir \\$computer\c$\elastic\filebeat

# Copy agent files to host
robocopy \\mynetworkhost\share\elastic\filebeat \\$computer\c$\elastic\filebeat\ /E
robocopy \\$computer\c$\elastic\filebeat.backup \\$computer\c$\elastic\filebeat\ /E

# Create the service
C:\Windows\System32\PSExec.exe \\$computer cmd /c "$command"

# Start the service
C:\Windows\System32\PSExec.exe \\$computer cmd /c "net start filebeat"