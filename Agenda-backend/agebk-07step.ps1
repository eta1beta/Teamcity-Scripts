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
$appPool = "sup-$normalizedBranchName"
$installationPath = "$ROOT_DIRECTORY\$normalizedBranchName"

$apps = @(
    "AgendaBackend"
)

# Crea AppPool con il nome del branch
New-WebAppPool -Name $appPool `
               -Force `
               -Verbose
Set-ItemProperty IIS:\AppPools\$appPool `
                 managedRuntimeVersion "v4.0" `
                 -Verbose
Set-ItemProperty IIS:\AppPools\$appPool `
                -Name "enable32BitAppOnWin64" `
                -Value "true" `
                -Verbose

# Crea tutte le application
foreach ($app in $apps) {

	$elmahpath ="$installationPath\$app\App_data"
	New-Item -ItemType Directory -Path "$elmahpath"
	$Acl = Get-Acl $elmahpath
	$rule = New-Object   System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS","FullControl","Allow")
	$Acl.AddAccessRule($rule)
	Set-Acl -path $elmahpath $Acl    

	New-WebApplication -Name $app `
                       -ApplicationPool $appPool `
                       -PhysicalPath "$installationPath\$app" `
                       -Site $site `
                       -Verbose
}