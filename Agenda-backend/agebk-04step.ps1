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

$installationPath = "$ROOT_DIRECTORY\$normalizedBranchName"

Remove-Item "$installationPath" -Force -Recurse
New-Item -ItemType Directory -Path "$installationPath"