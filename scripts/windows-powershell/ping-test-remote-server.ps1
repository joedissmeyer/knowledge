# Last edit: 2014-08-13
# by Joe Dissmeyer | Thwack.com - @JoeDissmeyer | Twitter - @JoeDissmeyer | www.joedissmeyer.com
# Powershell script to test a connection by PINGing the remote server and reply back.
# Uses the Test-Connection CMDLET to test a connection to a server.
# If the connection fails, the output will display to the screen, and set the communicationtestok variable
# Zero means OK, 1 means failure. 
#
# Intended to be used for SolarWinds. Useful for when the computer is still online and the monitored apps
# are still online, but the node cannot talk to the server for some reason.
#

$server = "SERVER_HOSTNAME_HERE"    # Script will fail without double quotes surrounding this variable

 if(!(Test-Connection -Cn $server -BufferSize 16 -Count 1 -ea 0 -quiet))
 {
        $stat = 1
        $msg = "Unable to PING $server"
     
 } # end if

ELSE {
        $stat = 0
        $msg = "Communication OK with $server"
     }

Write-Host "Statistic: $stat"
Write-Host $msg