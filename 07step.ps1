import-module webadministration

$ROOT_DIRECTORY = "C:\inetpub\teamcity-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')

$site = "Default Web site\tc-branch\$normalizedBranchName"
$appPool = "$normalizedBranchName"
$installationPath = "$ROOT_DIRECTORY\$normalizedBranchName"

$apps = @(
    "Admissions",
    "AdmissionsAPI",
    "AdmissionsReferees",
    "Appointments",
    "ClickR",
    "Ldap.API",
    "Portal",
    "PortalAPI",
    "PortalWidget",
    "Presences",
    "PresencesAPI",
    "Presences.Public",
    "Recognition",
    "Reports",
    "ResetPasswordAPI",
    "ResetPassword",
    "ValidatorFields"
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

	## New-WebApplication -Name $app `
    ##                    -ApplicationPool $appPool `
    ##                    -PhysicalPath "$installationPath\$app" `
    ##                    -Site $site `
    ##                    -Verbose
}
foreach ($app in $apps) {

	## $elmahpath ="$installationPath\$app\App_data"
	## New-Item -ItemType Directory -Path "$elmahpath"
	## $Acl = Get-Acl $elmahpath
	## $rule = New-Object   System.Security.AccessControl.FileSystemAccessRule("IIS_IUSRS","FullControl","Allow")
	## $Acl.AddAccessRule($rule)
	## Set-Acl -path $elmahpath $Acl    

	New-WebApplication -Name $app `
                       -ApplicationPool $appPool `
                       -PhysicalPath "$installationPath\$app" `
                       -Site $site `
                       -Verbose
}