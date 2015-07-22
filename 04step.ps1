$ROOT_DIRECTORY = "C:\inetpub\teamcity-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')

$installationPath = "$ROOT_DIRECTORY\$normalizedBranchName"

Remove-Item "$installationPath" -Force -Recurse
New-Item -ItemType Directory -Path "$installationPath"