# SYSLOG SCRIPT - SENDS A SYSLOG MESSAGE OVER A UDP PORT USING POWERSHELL

# Destination of the message - this is what is going to receive the syslog
$Server = 'target_server_name'

$Message = 'From  - PowerShell'

#0=EMERG 1=Alert 2=CRIT 3=ERR 4=WARNING 5=NOTICE  6=INFO  7=DEBUG
$Severity = '6'

#(16-23)=LOCAL0-LOCAL7
$Facility = '22'

$Hostname= 'JoeyDTest'

# Create a UDP Client Object. Change port if needed. Port number is typically 514.
$UDPCLient = New-Object System.Net.Sockets.UdpClient
$UDPCLient.Connect($Server, 514)

# Calculate the priority
$Priority = ([int]$Facility * 8) + [int]$Severity

#Time format the SW syslog understands
$Timestamp = Get-Date -Format "MMM dd HH:mm:ss"

# Assemble the full syslog formatted message
$FullSyslogMessage = "<{0}>{1} {2} {3}" -f $Priority, $Timestamp, $Hostname, $Message

# create an ASCII Encoding object
$Encoding = [System.Text.Encoding]::ASCII

# Convert into byte array representation
$ByteSyslogMessage = $Encoding.GetBytes($FullSyslogMessage)

# Send the Message
$UDPCLient.Send($ByteSyslogMessage, $ByteSyslogMessage.Length)