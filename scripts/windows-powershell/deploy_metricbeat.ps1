# Deploy Metricbeat script - Works with Metricbeat v6.x only
#
# Uses the SC CREATE command line with PSEXEC to deploy and create the services.
# Metricbeat, and all sub-folders, must be copied to the node locally in order for this to work.
# Execute this script to deploy the Metricbeat agent. Must use an account with admin rights to run this script.


$computer = "my-hostname"

$PSExec = "C:\Windows\System32\PSExec.exe"
$command1 = 'sc create metricbeat binPath= "c:\elastic\metricbeat\metricbeat.exe -c c:\elastic\metricbeat\metricbeat.yml -path.home -c:\elastic\metricbeat\ -path.data c:\elastic\metricbeat" start= auto'
$command2 = 'net start metricbeat'

mkdir \\$computer\c$\elastic\
robocopy \\mynetworkhost\share\elastic\metricbeat \\$computer\d$\elastic\metricbeat\ /E
