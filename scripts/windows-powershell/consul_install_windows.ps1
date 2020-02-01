# Run this script from the D:\scripts\ path.

# Define variables
$download_file = "consul_1.6.2_windows_amd64.zip"
$url = "https://releases.hashicorp.com/consul/1.6.2/$download_file"
$output = "c:\consul\$download_file"

# Set up directories
mkdir c:\consul\
mkdir c:\consul\configs
mkdir c:\consul\logs
mkdir c:\consul\scripts

# Download the Consul ZIP file
[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
Invoke-WebRequest -Uri $url -OutFile $output

# Unzip to proper destination
Expand-Archive $output -DestinationPath D:\consul
Remove-Item -Force $output

# Write config files
Write-Output '{
  "datacenter": "my-datacenter",
  "data_dir": "C:\\consul",
  "encrypt": "bogusencryptkey",
  "log_level": "INFO",
  "server": false,
  "rejoin_after_leave": true,
  "retry_join": [
    "consul-server1.domain.com",
    "consul-server2.domain.com",
    "consul-server3.domain.com"
  ],
  "enable_script_checks": true,
  "telemetry": {
    "prometheus_retention_time": "1m"
  },
  "recursors": [ "my-dns-recursor.domain.com" ]
  "ports": { "dns": 53 }
}' | Out-File -FilePath D:\consul\configs\consul.json -Encoding utf8

# Create the Consul service
sc.exe create "Consul" binPath="C:\consul\consul.exe agent -config-dir=C:\consul\configs -log-file=C:\consul\logs\consul.log -log-rotate-max-files=7" start= auto

# Start the Consul service
net start consul

# Add Consul to the PATH Environment Variable. Allows running "consul" from PS or CMD without having to nav to the directory path first
$oldpath = (Get-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH).path
$newpath = "$oldpath;c:\consul"
Set-ItemProperty -Path 'Registry::HKEY_LOCAL_MACHINE\System\CurrentControlSet\Control\Session Manager\Environment' -Name PATH -Value $newPath


#Add localhost as a DNS source. Allows for the Consul agent's DNS interface to be used on the Windows host
# This is a special requirement for Windows only. Linux uses DNSMASQ configuration instead.
#netsh interface ipv4 add dnsserver \"Consul\" address=127.0.0.1 index=1

#Review active ports on windows
#netstat -abno | Findstr 53