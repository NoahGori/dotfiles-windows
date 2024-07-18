function Set-WindowsExplorer-ShowFileExtensions {
  Write-Host "Configuring Windows File Explorer to show file extensions:" -ForegroundColor "Green";

  $RegPath = "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
  Set-ItemProperty -Path $RegPath -Name "HideFileExt" -Value 0;
}

function Set-WindowsFileExplorer-StartFolder {
  Write-Host "Configuring start folder of Windows File Explorer:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";

  if (-not (Test-PathRegistryKey -Path $RegPath -Name "LaunchTo")) {
    New-ItemProperty -Path $RegPath -Name "LaunchTo" -PropertyType DWord;
  }

  Set-ItemProperty -Path $RegPath -Name "LaunchTo" -Value 1; # [This PC: 1], [Quick access: 2], [Downloads: 3]
}

function Set-Multitasking-Configuration {
  Write-Host "Configuring Multitasking settings (Snap layouts):" -ForegroundColor "Green";
  
  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";

  # When I snap a window, show what I can snap next to it.
  Set-ItemProperty -Path $RegPath -Name "SnapAssist" -Value 0;
  # Show snap layouts that the app is part of when I hover over the taskbar buttons.
  Set-ItemProperty -Path $RegPath -Name "EnableTaskGroups" -Value 0;
  # When I resize a snapped window, simultaneously resize any adjacent snapped window.
  Set-ItemProperty -Path $RegPath -Name "JointResize" -Value 0;

  # Show snap layout when I hover over a window's maximize button.
  Set-ItemProperty -Path $RegPath -Name "EnableSnapAssistFlyout" -Value 1;
  # When I drag a window, let me snap it without dragging all the way to the screen edge.
  Set-ItemProperty -Path $RegPath -Name "DITest" -Value 1;
  # When I snap a window, automatically size it to fill available space.
  Set-ItemProperty -Path $RegPath -Name "SnapFill" -Value 1;

  Write-Host "Multitasking successfully updated." -ForegroundColor "Green";
}


function Disable-RecentlyOpenedItems-From-JumpList {
  Write-Host "Configuring Jump List to do not show the list of recently opened items:" -ForegroundColor "Green";

  $RegPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced";
  if (-not (Test-PathRegistryKey -Path $RegPath -Name "Start_TrackDocs")) {
    New-ItemProperty -Path $RegPath -Name "Start_TrackDocs" -PropertyType DWord;
  }
  Set-ItemProperty -Path $RegPath -Name "Start_TrackDocs" -Value 0;
}

function Set-Power-Configuration {
  Write-Host "Configuring power plan:" -ForegroundColor "Green";
  # AC: Alternating Current (Wall socket).
  # DC: Direct Current (Battery).

  # Set turn off disk timeout (in minutes / 0: never)
  powercfg -change "disk-timeout-ac" 0;
  powercfg -change "disk-timeout-dc" 0;
  
  # Set hibernate timeout (in minutes / 0: never)
  powercfg -change "hibernate-timeout-ac" 0;
  powercfg -change "hibernate-timeout-dc" 0;

  # Set sleep timeout (in minutes / 0: never)
  powercfg -change "standby-timeout-ac" 0;
  powercfg -change "standby-timeout-dc" 0;

  # Set turn off screen timeout (in minutes / 0: never)
  powercfg -change "monitor-timeout-ac" 10;
  powercfg -change "monitor-timeout-dc" 10;

  # Set turn off screen timeout on lock screen (in seconds / 0: never)
  powercfg /SETACVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 30;
  powercfg /SETDCVALUEINDEX SCHEME_CURRENT SUB_VIDEO VIDEOCONLOCK 30;
  powercfg /SETACTIVE SCHEME_CURRENT;

  Write-Host "Power plan successfully updated." -ForegroundColor "Green";
}

Disable-WindowsFeature "WindowsMediaPlayer" "Windows Media Player";
Disable-WindowsFeature "Internet-Explorer-Optional-amd64" "Internet Explorer";
Disable-WindowsFeature "Printing-XPSServices-Features" "Microsoft XPS Document Writer";
Disable-WindowsFeature "WorkFolders-Client" "WorkFolders-Client";
Enable-WindowsFeature "Containers-DisposableClientVM" "Windows Sandbox";

Uninstall-AppPackage "Microsoft.Getstarted";
Uninstall-AppPackage "Microsoft.GetHelp";
Uninstall-AppPackage "Microsoft.WindowsFeedbackHub";
Uninstall-AppPackage "Microsoft.MicrosoftSolitaireCollection";

Set-WindowsExplorer-ShowFileExtensions;
Set-WindowsFileExplorer-StartFolder;
Set-Multitasking-Configuration;
Disable-RecentlyOpenedItems-From-JumpList;
Set-Power-Configuration;