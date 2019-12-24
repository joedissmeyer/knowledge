# ***************************************************************************
# ***************************************************************************
# *****                                                                 *****
# ***** Test to check for duplicate URLs in Heartbeat HTTP monitor YMLs *****
# *****                                                                 *****
# *****    Specifically designed for the test to run in GitLab CI/CD    *****
# *****                                                                 *****
# ***************************************************************************
# ***************************************************************************

# Variable definitions
$Path = ".\monitors\"
$Text = "url"
$PathArray = @()
$LASTEXITCODE = 0

# ErrorActionPreference must be included as a variable to use for Gitlab CI to return 
# the correct error exit code for Gitlab if a failure occurs.
# More information about this can be found here: https://gitlab.com/gitlab-org/gitlab-runner/issues/1514
$ErrorActionPreference = 'Stop'

# Recursively store all file names and paths in array.
# Specifically looks for ".yml" file extensions.

Get-ChildItem $Path -Filter "*.yml" -Recurse | Where-Object { $_.Attributes -ne "Directory"} | ForEach-Object {
  If (Get-Content $_.FullName | Select-String -SimpleMatch $Text) {
    $PathArray += $_.FullName
  }
}

# Iterate through each object in the path array to parse for duplicate URLs

$PathArray | ForEach-Object {

  [string[]]$arrayFromFile = Get-Content -Path "$_" | Select-String -SimpleMatch 'url'
  $b = $arrayFromFile | Select-Object -Unique
  $resultcount = (Compare-Object -ReferenceObject $b -DifferenceObject $arrayFromFile).Count
  $result = Compare-Object -ReferenceObject $b -DifferenceObject $arrayFromFile

  if ( $resultcount -gt 0 ) {
    # Set LASTEXITCODE to 1 if there are 
    $LASTEXITCODE = 1
    Write-Host "Result message       : Error, test failed. Duplicates found in configuration file: $_."
    Write-Host "Count of duplicates  :" $resultcount
    Write-Host "What was found       :" $result
  }

  else {
    # return the exit code of 0. 0 = Success
    Write-Host "Result message       : Success. All is well with config file: $_."
  }
}

# Return last exit code
Exit $LASTEXITCODE