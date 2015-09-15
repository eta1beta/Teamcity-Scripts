$ROOT_DIRECTORY = "C:\inetpub\quicksupport-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')

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