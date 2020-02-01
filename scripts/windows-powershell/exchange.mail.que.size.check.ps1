# Script that gets the current file size of the mail.que file on each Exchange server and outputs each result to a file.
# The file can then be harvested by Filebeat for ingestion into the Elastic Stack.
# 
# Script must be executed using a service account that has read access to the file path on each server.
# 

Remove-Item C:\elastic\logs\exchange.mail.que.size.log

$serverlist = @("10.10.1.1","10.10.1.2","10.10.1.3")

$dateandtime = Get-Date -Format "o"

foreach ($server in $serverlist)
{
    $result = (Get-Item "\\$server\D$\Program Files\Microsoft\Exchange Server\V15\TransportRoles\data\Queue\mail.que").length
    Write-Host "$server - $result"
    echo "$dateandtime - hostname: $server - mail.que.bytes: $result" >> 'c:\logs\exchange.mail.que.size.log'
}
return 0;