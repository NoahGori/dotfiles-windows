$GitHubRepositoryUri = "https://github.com/${GitHubRepositoryAuthor}/${GitHubRepositoryName}/archive/refs/heads/main.zip";

$DotfilesFolder = Join-Path -Path $HOME -ChildPath ".dotfiles";
$ZipRepositoryFile = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main.zip";
$DotfilesWorkFolder = Join-Path -Path $DotfilesFolder -ChildPath "${GitHubRepositoryName}-main" | Join-Path -ChildPath "apps";

$DownloadResult = $FALSE;

# Request custom values
$id = [System.Security.Principal.WindowsIdentity]::GetCurrent()

$p = New-Object System.Security.Principal.WindowsPrincipal($id)

if ($p.IsInRole([System.Security.Principal.WindowsBuiltInRole]::Administrator))
{ 
  Write-Host "Running with Admin Privileges" 
}     
else
{ 
  Write-Output "Administrator privileges not detected. Please re-run script with Admin Privileges!";
  exit -1
}

$GitUserName = Read-Host -Prompt "Input your Git user name here";

$GitUserEmail = Read-Host -Prompt "Input your Git user email here";

do {
  $WorkComputer = Read-Host -Prompt "Is this a work machine? (y/n)";
}
while (($WorkComputer -ne "y") -and ($WorkComputer -ne "n"))


$ValidDisks = Get-PSDrive -PSProvider "FileSystem" | Select-Object -ExpandProperty "Root";
do {
  Write-Host "Choose the location of your development workspace:" -ForegroundColor "Green";
  Write-Host $ValidDisks -ForegroundColor "Green";
  $WorkspaceDisk = Read-Host -Prompt "Please choose one of the available disks";
}
while (-not ($ValidDisks -Contains $WorkspaceDisk));

# Create Dotfiles folder
if (Test-Path $DotfilesFolder) {
  Remove-Item -Path $DotfilesFolder -Recurse -Force;
}
New-Item $DotfilesFolder -ItemType directory;

# Download Dotfiles repository as Zip
Try {
  Invoke-WebRequest $GitHubRepositoryUri -OutFile $ZipRepositoryFile;
  $DownloadResult = $TRUE;
}
catch [System.Net.WebException] {
  Write-Host "Error connecting to GitHub, check the internet connection or the repository url." -ForegroundColor "Red";
}

if ($DownloadResult) {
  Add-Type -AssemblyName System.IO.Compression.FileSystem;
  [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipRepositoryFile, $DotfilesFolder);
  Invoke-Expression (Join-Path -Path $DotfilesWorkFolder -ChildPath "Setup.ps1");
}