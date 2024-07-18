function Set-VSCode-Configuration {
  $VSCodeSettingsPath = Join-Path -Path $env:appdata -ChildPath "Code" | Join-Path -ChildPath "User";
  $DotfilesVSCodeSettingsFolder = Join-Path -Path $DotfilesWorkFolder -ChildPath "VSCode";
  
  if (-not (Test-Path -Path $VSCodeSettingsPath)) {
    Write-Host "Configuring Visual Studio Code:" -ForegroundColor "Green";
    New-Item $VSCodeSettingsPath -ItemType directory;
  }

  Get-ChildItem -Path "${DotfilesVSCodeSettingsFolder}\*" -Include "*.json" -Recurse | Copy-Item -Destination $VSCodeSettingsPath;
}

choco install -y "vscode" --params "/NoDesktopIcon /NoQuicklaunchIcon";
Set-VSCode-Configuration;
refreshenv;
code-insiders --install-extension "ue.alphabetical-sorter";
code-insiders --install-extension "ms-azuretools.vscode-docker";
code-insiders --install-extension "usernamehw.errorlens";
code-insiders --install-extension "eamodio.gitlens";
code-insiders --install-extension "oderwat.indent-rainbow";
code-insiders --install-extension "davidanson.vscode-markdownlint";
code-insiders --install-extension "robole.markdown-snippets";
code-insiders --install-extension "pkief.material-icon-theme";
code-insiders --install-extension "ms-vscode.powershell";
code-insiders --install-extension "esbenp.prettier-vscode";
code-insiders --install-extension "ms-vscode-remote.remote-containers";
code-insiders --install-extension "ms-vscode-remote.remote-wsl";
code-insiders --install-extension "rangav.vscode-thunder-client";