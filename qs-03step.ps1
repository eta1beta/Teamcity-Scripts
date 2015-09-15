import-module webadministration

function Trim-Length {
param (
    [parameter(Mandatory=$True,ValueFromPipeline=$True)] [string] $Str
  , [parameter(Mandatory=$True,Position=1)] [int] $Length
)
    $Str[0..($Length-1)] -join ""
}

$ROOT_DIRECTORY = "C:\inetpub\quicksupport-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')
$normalizedBranchName = $normalizedBranchName | Trim-Length 60

$site = "Default Web site\sup-branch\$normalizedBranchName"
$appPool = "sup-$normalizedBranchName"

$apps = @(
    "QuickSupport"
)

# Cancella tutte le application
foreach ($app in $apps) {
    Remove-WebApplication -Name $app -Site $site `
                          -Verbose `
                          -ErrorAction Ignore
}

# Cancella AppPool con il nome del branch
Remove-WebAppPool -Name $appPool `
                  -Verbose `
                  -ErrorAction Ignore