$ROOT_DIRECTORY = "C:\inetpub\quicksupport-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')

$installationPath = "$ROOT_DIRECTORY\$normalizedBranchName"

$apps = @{
    "QuickSupport\QuickSupport.csproj" = "QuickSupport";
}

foreach ($app in $apps.GetEnumerator()) {
    C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe `
        "dev\$($app.Name)" `
        /p:Configuration=Release `
        /p:DeployOnBuild=true `
        /p:PublishProfile=TeamCity `
        /p:publishUrl="$installationPath\$($app.Value)"
    if (-Not $?) { exit 1 }
}