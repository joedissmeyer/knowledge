$servicename = "consul"

$Service = Get-Service $servicename
if ($Service.Status -ne 'Running') 
    {
        $Service | Write-Output
        exit 2
    } 
else 
    {
        $Service | Write-Output
        exit 0
    }