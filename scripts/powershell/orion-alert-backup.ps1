# --- ORION-ALERT-BACKUP.ps1
# --- Author: Joseph Dissmeyer, www.dissmeyer.com
# --- Last updated: 2020-01-15
# --- Reference: https://thwack.solarwinds.com/message/433199#433199
# --- 
# --- Save as .ps1 file in your scripts directory.
# --- 
# --- How it works:
# --- Downloads all enabled alert rules from an Orion instance.
# --- Each rule is saved individually as .XML file to the same directory
# --- where the script is executed from.
#  
# Requirements:
# 1. OrionSDK. Download binaries from https://github.com/solarwinds/OrionSDK
# 2. An Orion basic user that has "Alert management rights" enabled.
# 3. Edit the hostname, username and password.
  
# Verify OrionSDK SwisSnapin presence  
if (!(Get-PSSnapin -Name "SwisSnapin" -ErrorAction SilentlyContinue))
{        
    Add-PSSnapin SwisSnapin -ErrorAction SilentlyContinue    
}      
  
# Define Variables  
$swis = Connect-Swis -Hostname my-orion-host.domain.com -Username alertbackup -Password Jello12#  
  
# Get all AlertIds, add to array
$AlertList = Get-SwisData $swis "SELECT AlertId FROM Orion.AlertConfigurations WHERE Enabled = True"  
$AlertIds = $AlertList -split ' '  

# Iterate through the Alertids array, back up each rule found
foreach($alertid in $AlertIds){  
  $alerttitle = Get-SwisData $swis "SELECT Name FROM Orion.AlertConfigurations WHERE AlertId = $alertid"  
  
  # remove all possible 'special characters' from the alert title
  $alerttitle = $alerttitle -replace '(#|\||"|,|/|:|\<|\>|\[|\]|%|$|@|â|€|™|\?)', ''  
  # remove all spaces from the alert title, replace with underscore
  $alerttitle = $alerttitle -replace '\s','_'  
  
  $filename = "$alerttitle-ID-$alertid.xml"  
    
  Set-Content $filename $ExportedAlert.InnerText  
  $ExportedAlert = Invoke-SwisVerb $swis Orion.AlertConfigurations Export @($alertid)
}

# End script