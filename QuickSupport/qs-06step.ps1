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

$files = Get-ChildItem -Path $installationPath -Filter Web.config -Recurse
ForEach ($file in $files) { 
    (gc $file.fullName) -replace "http://localhost", "http://sviluppo10/sup-branch/$normalizedBranchName" | `
        Set-Content $file.fullName -Force -Encoding UTF8
}

$files = Get-ChildItem -Path $installationPath -Filter App.config -Recurse
ForEach ($file in $files) { 
    (gc $file.fullName) -replace "http://localhost", "http://sviluppo10/sup-branch/$normalizedBranchName" | `
        Set-Content $file.fullName -Force -Encoding UTF8
}