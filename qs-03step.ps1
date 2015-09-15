import-module webadministration

$ROOT_DIRECTORY = "C:\inetpub\quicksupport-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')

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