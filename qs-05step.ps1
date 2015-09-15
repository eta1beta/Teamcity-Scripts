$ROOT_DIRECTORY = "C:\inetpub\quicksupport-branch"

function Trim-Length {
param (
    [parameter(Mandatory=$True,ValueFromPipeline=$True)] [string] $Str
  , [parameter(Mandatory=$True,Position=1)] [int] $Length
)
    $Str[0..($Length-1)] -join ""
}


$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')
$normalizedBranchName = $normalizedBranchName | Trim-Length 60

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