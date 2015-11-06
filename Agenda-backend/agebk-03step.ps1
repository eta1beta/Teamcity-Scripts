import-module webadministration

function Trim-Length {
param (
    [parameter(Mandatory=$True,ValueFromPipeline=$True)] [string] $Str
  , [parameter(Mandatory=$True,Position=1)] [int] $Length
)
    $Str[0..($Length-1)] -join ""
}

$ROOT_DIRECTORY = "C:\inetpub\agendabackend-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')
$normalizedBranchName = $normalizedBranchName | Trim-Length 60

$site = "Default Web site\agebe-branch\$normalizedBranchName"
$appPool = "agebe-$normalizedBranchName"

$apps = @(
    "AgendaBackend"
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