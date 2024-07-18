function Update-Ubuntu-Packages-Repository {
  Write-Host "Updating Ubuntu package repository:" -ForegroundColor "Green";
  ubuntu run sudo apt --yes update;
}

function Update-Ubuntu-Packages {
  Write-Host "Upgrading Ubuntu packages:" -ForegroundColor "Green";
  ubuntu run sudo apt --yes upgrade;
}

function Install-Ubuntu-Package {
  [CmdletBinding()]
  param(
    [Parameter(Position = 0, Mandatory = $TRUE)]
    [string]
    $PackageName
  )

  Write-Host "Installing ${PackageName} in Ubuntu:" -ForegroundColor "Green";
  ubuntu run sudo apt install --yes --no-install-recommends $PackageName;
}

function Set-Git-Configuration-In-Ubuntu {
  Write-Host "Configuring Git in Ubuntu:" -ForegroundColor "Green";
  ubuntu run git config --global init.defaultBranch "main";
  ubuntu run git config --global user.name $Config.GitUserName;
  ubuntu run git config --global user.email $Config.GitUserEmail;
  ubuntu run git config --global credential.helper "/mnt/c/Program\ Files/Git/mingw64/libexec/git-core/git-credential-manager-core.exe";
  ubuntu run git config --list;
  Write-Host "Git was successfully configured in Ubuntu." -ForegroundColor "Green";
}

function Install-VSCode-Extensions-In-ubuntu run {
  Write-Host "Installing Visual Studio Code extensions in WSL:" -ForegroundColor "Green";

  ubuntu run code --install-extension ue.alphabetical-sorter;
  ubuntu run code --install-extension ms-azuretools.vscode-docker;
  ubuntu run code --install-extension eamodio.gitlens;
  ubuntu run code --install-extension oderwat.indent-rainbow;
  ubuntu run code --install-extension davidanson.vscode-markdownlint;
  ubuntu run code --install-extension esbenp.prettier-vscode;
  ubuntu run code --install-extension rangav.vscode-thunder-client;
}


function Install-OhMyZsh-In-Ubuntu {
  $DotfilesOhMyZshInstallerPath = Join-Path -Path $DotfilesWorkFolder -ChildPath "WSL" | Join-Path -ChildPath "ohmyzsh.sh";

  Invoke-WebRequest -o $DotfilesOhMyZshInstallerPath https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh;

  $WslOhMyZshInstallerPath = ubuntu run wslpath $DotfilesOhMyZshInstallerPath.Replace("\", "\\");
  
  Write-Host "Installing Oh My Zsh in Ubuntu:" -ForegroundColor "Green";
  
  ubuntu run bash $WslOhMyZshInstallerPath --unattended;
}

function Install-Zsh-Autosuggestions {
  $ZshAutosuggestionsWslPath = "~/.oh-my-zsh/custom/plugins/zsh-autosuggestions";

  Write-Host "Installing Zsh-Autosuggestions in Ubuntu:" -ForegroundColor "Green";

  ubuntu run rm -rf $ZshAutosuggestionsWslPath;

  ubuntu run git clone https://github.com/zsh-users/zsh-autosuggestions $ZshAutosuggestionsWslPath;
}

function Install-OhMyZsh-Theme-In-Ubuntu {
  $DotfilesOhMyZshThemePath = Join-Path -Path $DotfilesWorkFolder -ChildPath "WSL" | Join-Path -ChildPath "paradox.zsh-theme";
  $WslOhMyZshThemePath = ubuntu run wslpath $DotfilesOhMyZshThemePath.Replace("\", "\\");

  Write-Host "Installing Paradox theme for Oh My Zsh in Ubuntu:" -ForegroundColor "Green";

  ubuntu run cp -R $WslOhMyZshThemePath ~/.oh-my-zsh/custom/themes;
}

function Install-OhMyZsh-Functions-In-Ubuntu {
  $DotfilesOhMyZshFunctionsPath = Join-Path -Path $DotfilesWorkFolder -ChildPath "WSL" | Join-Path -ChildPath "custom-actions.sh";
  $WslOhMyZshFunctionsPath = ubuntu run wslpath $DotfilesOhMyZshFunctionsPath.Replace("\", "\\");

  Write-Host "Installing custom alias and functions for Oh My Zsh in Ubuntu:" -ForegroundColor "Green";

  ubuntu run mkdir -p ~/.oh-my-zsh/custom/functions;

  ubuntu run cp -R $WslOhMyZshFunctionsPath ~/.oh-my-zsh/custom/functions;
}

function Set-OhMyZsh-Configuration-In-Ubuntu {
  $DotfilesZshrcPath = Join-Path -Path $DotfilesWorkFolder -ChildPath "WSL" | Join-Path -ChildPath ".zshrc";
  $WslZshrcPath = ubuntu run wslpath $DotfilesZshrcPath.Replace("\", "\\");

  Write-Host "Configuring Zsh in Ubuntu:" -ForegroundColor "Green";
  
  ubuntu run cp -R $WslZshrcPath ~;
}

function Set-Zsh-As-Default-In-Ubuntu {
  Write-Host "Changing default shell to Zsh in Ubuntu:" -ForegroundColor "Green";

  $WslZshPath = ubuntu run which zsh;
  ubuntu run sudo chsh -s $WslZshPath;

  # Change just for a user: sudo chsh -s $WslZshPath $USER_NAME;
}

ubuntu run --install
refreshenv
ubuntu run --install -d Ubuntu
refreshenv

$UbuntuInstallStatus = ubuntu run -l |Where {$_.Replace("`0","") -match '^Ubuntu'}
if ($UbuntuInstallStatus -eq $null) {
  Write-Host "Ubuntu not installed. PC will restart in 10 seconds";
  
  Start-Sleep -Seconds 10;
}
else {
  Write-Host "Ubuntu installed! Proceeding with dotfiles script";
  ubuntu run --set-default Ubuntu
}

Update-Ubuntu-Packages-Repository;
Update-Ubuntu-Packages;

Install-Ubuntu-Package -PackageName "curl";
Install-Ubuntu-Package -PackageName "neofetch";
Install-Ubuntu-Package -PackageName "git";
Install-Ubuntu-Package -PackageName "zsh";
Install-Ubuntu-Package -PackageName "make";
Install-Ubuntu-Package -PackageName "g++";
Install-Ubuntu-Package -PackageName "gcc";

Set-Git-Configuration-In-Ubuntu;

Install-VSCode-Extensions-In-WSL;

Install-OhMyZsh-In-Ubuntu;
Install-OhMyZsh-Theme-In-Ubuntu;
Install-OhMyZsh-Functions-In-Ubuntu;
Set-OhMyZsh-Configuration-In-Ubuntu;
Set-Zsh-As-Default-In-Ubuntu;