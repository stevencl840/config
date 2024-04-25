Import-Module posh-git
oh-my-posh init pwsh --config 'c:\users\steve\mine.omp.json' | Invoke-Expression
$repo = $env:REPO

function repo { Set-Location $repo }

function fromBase64String ([string]$arg) {
    Write-Host [System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String($arg));
}

function toBase64String ([string]$arg) {
    Write-Host [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes($arg));
}

function gco {
    $branch = $args[0]
    git checkout "$branch"
}

function gcob {
    $branch = $args[0]
    git checkout -b "$branch"
}

function gcom {
    git checkout main
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

function gs {
    git status
}

function gpwr {
    $branch = $args[0]

    if ($branch -eq "") {
        throw new Error("No branch provided.")
    }

    if ($branch.ToString().StartsWith("release")) {

    }

    gco main
    git pull
    git checkout $branch
    git rebase main
    git push origin "$branch"
}

function gbd {
    git branch -d $args[0]
}

function gbdf {
    git branch -D $args[0]
}

function gst { git status }
function gtp { git pull }
function gb { git branch }
function gbr { git branch -r }
function gtcm { git commit -m "$args" }
function gau { git add -u }


function gmm {
    $parentBranch = "main"

    $branch = $(git rev-parse --abbrev-ref HEAD)
       
    gco $parentBranch
    git pull
    git checkout "$branch"
    git merge $parentBranch
    git push origin "$branch"
}

function azlsacc {
    $subscriptionName = $args[0]
    az account list --query "[?starts_with(name,'$subscriptionName')].Name{Name:name, SubscriptionId:id)}"
}

function grs {
    git reset --soft HEAD~1
}

Invoke-Expression (& { (zoxide init powershell | Out-String) })

Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+t' -PSReadlineChordReverseHistory 'Ctrl+r'

$commandOverride = [ScriptBlock] { param($Location) Write-Host $Locoation }

Set-PsFzfOption -AltCCommand $commandOverride

function fzf {
    Invoke-fzf | Set-Clipboard
}

function dps {
    docker ps --format "table {{.ID}}\t{{.Image}}\t{{.Status}}\t{{.Names}}"
}
