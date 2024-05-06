Import-Module posh-git

oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\agnoster.minimal.omp.json" | Invoke-Expression
$repo = 'D:\repo'
$odRepo = $repo + '\OctopusDeploy'
$ghwaRepo = $repo + '\GitHubWebApp'

############# Personal Location Aliases
function repo { Set-Location $repo }
function odRepo { Set-Location $odRepo }
function ghwaRepo { Set-Location $ghwaRepo }

function glsb { 
    $branchName = git branch --sort=-committerdate | invoke-fzf
    $branchName.SubString(2) | Set-Clipboard
}
    

function glsbr { git branch -r --list *sjc* }

function gpu { git pull }

function gco {
    $branch = $args[0]
    git checkout "$branch"
}

function gcob {
    $branch = $args[0]
    git checkout -b "$branch"

    git push --set-upstream origin "$branch"
}

function gcom {
    gco main
    git pull
}

function gpo {
    $branch = $args[0]
    git push origin "$branch"
}

function gpfo {
    $branch = $args[0]
    git push -f origin "$branch"

}

function gpwr {
    $branch = $(git rev-parse --abbrev-ref HEAD)

    gco main
    git pull
    git checkout $branch
    git rebase main
    git push origin "$branch"
}

function gmm {
    $parentBranch = "main"

    $branch = $(git rev-parse --abbrev-ref HEAD)
       
    gco $parentBranch
    git pull
    git checkout "$branch"
    git merge $parentBranch
    git push origin "$branch"
}
function grs {
    git reset --soft HEAD~1
}

function gs {
    git status
}

function azlsacc {
    $subscriptionName = $args[0]

    az account list --query "[?starts_with(name,'$subscriptionName')].{Name:name, SubscriptionId:id}"
}



Invoke-Expression (& { (zoxide init powershell | Out-String) })

# replace 'Ctrl+t' and 'Ctrl+r' with your preferred bindings:
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

# example command - use $Location with a different command:
$commandOverride = [ScriptBlock] { param($Location) Write-Host $Location }
# pass your override to PSFzf:
Set-PsFzfOption -AltCCommand $commandOverride

function fzf {
    Invoke-fzf | Set-Clipboard
}

function dps {
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
}
# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
    Import-Module "$ChocolateyProfile"
}

function dockOd {
    odRepo

    docker compose -f .\docker-compose.deps.yml up -d
}

function dockGhwa {
    $currentPwd = $pwd
    dockOd
    ghwaRepo
    docker compose up -d
    docker stop githubwebapp-prometheus-1
    
    Set-Location $currentPwd

    dps
}
