function Set-Configuration-File {
  [CmdletBinding()]
  param (
    [Parameter( Position = 0, Mandatory = $TRUE)]
    [String]
    $DotfilesConfigFile,
    
    [Parameter( Position = 1, Mandatory = $TRUE)]
    [String]
    $GitUserName,
    
    [Parameter( Position = 2, Mandatory = $TRUE)]
    [String]
    $GitUserEmail,

    [Parameter( Position = 3, Mandatory = $TRUE)]
    [String]
    $WorkspaceDisk,

    [Parameter( Position = 4, Mandatory = $TRUE)]
    [String]
    $WorkComputer
  )

  if (-not (Test-Path -Path $DotfilesConfigFile)) {
    Write-Host "Creating config.json file:" -ForegroundColor "Green";
    $ConfigJsonBody = [PSCustomObject]@{
      GitUserName   = $GitUserName
      GitUserEmail  = $GitUserEmail
      WorkspaceDisk = $WorkspaceDisk
      WorkComputer = $WorkComputer
    };

    Set-Content -Path $DotfilesConfigFile -Value ($ConfigJsonBody | ConvertTo-Json);

    Write-Host "config.json file successfully created." -ForegroundColor "Green";
  }
}

function Get-Configuration-File {
  [CmdletBinding()]
  param (
    [Parameter( Position = 0, Mandatory = $TRUE)]
    [String]
    $DotfilesConfigFile
  )
  
  $Config = @{};
  $ConfigContent = Get-Content $DotfilesConfigFile | ConvertFrom-Json;

  Write-Host "Reading config.json file:" -ForegroundColor "Green";

  foreach ($Property in $ConfigContent.PSObject.Properties) {
    $Config[$Property.Name] = $Property.Value;
  }
  
  Write-Host "config.json contains:" -ForegroundColor "Green";
  Write-Host -ForegroundColor "Green" ($Config | Out-String);

  return $Config;
}