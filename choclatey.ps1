Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

choco install docker-desktop 

choco install fzf 
choco install git 
choco install gh
choco install k9s 

choco install kind 
choco install kubectx 
choco install kubens 
choco install kubernetes-cli 
choco install oh-my-posh 
choco install poshgit 

choco install python3 
choco install 7zip

echo https://github.com/microsoft/cascadia-code/releases
