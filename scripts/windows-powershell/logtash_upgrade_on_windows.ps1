# Updated for v6.8
# Run this script from the c:\scripts\ path.

$input_new_version = Read-Host -Prompt "Input version to upgrade to : "
$input_old_version = Read-Host -Prompt "Input version upgrading from: "

# Define variables

$logstash_version = "logstash-$input_new_version"
$old_logstash_version = "logstash-$input_old_version"
$logstash_file = "$logstash_version.zip"
$url = "https://artifacts.elastic.co/downloads/logstash/$logstash_file"
$output = "c:\elastic\$logstash_file"
$config_source = "c:\elastic\logstash\config"
$driver_source = "c:\elastic\logstash\driver"
$pipeline_source = "c:\elastic\logstash\bin\pipelines"

# Download the new Logstash version

[Net.ServicePointManager]::SecurityProtocol = "tls12, tls11, tls"
Invoke-WebRequest -Uri $url -OutFile $output

# Unzip to proper destination

Expand-Archive c:\elastic\$logstash_file -DestinationPath D:\elastic

# Copy configurations from old version to new

md -path "c:\elastic\$logstash_version\driver"
md -path "c:\elastic\$logstash_version\bin\pipelines"
md -path "c:\elastic\$logstash_version\logs"

Copy-Item "$config_source" -Destination "c:\elastic\$logstash_version\" -Recurse -force
Copy-Item "$driver_source" -Destination "c:\elastic\$logstash_version\" -Recurse -force
Copy-Item "$pipeline_source" -Destination "c:\elastic\$logstash_version\bin\" -Recurse -force


# Stop the Logstash service

net stop logstash

# Rename install folders. 

Rename-Item c:\elastic\logstash c:\elastic\$old_logstash_version
Rename-Item c:\elastic\$logstash_version c:\elastic\logstash

# Start the Logstash service

net start logstash