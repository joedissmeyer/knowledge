# 2014-04-28 : Windows Powershell Script by Joe Dissmeyer
# Built for use in SolarWinds but can be edited.
# First, the script checks to see if a specific Windows process (EXE) is running at this moment in time.
# If so, then the IF routine is executed. 
# If not, the then the ELSE routine is executed.
# The numeric value stored in the variable $stat will be your threshold for SolarWinds SAM monitoring.


# Define the process name in $processname. It should only include the name of the app and should not include the file extension.
# NOTEPAD is valid. NOTEPAD.EXE is not. Don’t forget the single quotes around the app name or the script will fail.

$processname = 'Notepad'
$process = Get-Process $processname -ErrorAction silentlycontinue

# If the process is running right now, do this
if ($process)
{
   # Store the total count of instances as a numeric value in COUNT
   $count = @($process).Count
    $msg = "$count instances of $processname running."
    $stat = $count
    
}

# If the process is not running right now, do this
else 
{
  $msg = "$processname is not running."
  $stat = 0
}

# Display the message
Write-Host $msg

# Display the statistic value
Write-Host "Statistic: $stat"