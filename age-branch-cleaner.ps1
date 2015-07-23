$Now = Get-Date
$Days = "20"
$TargetFolder = "C:\inetpub\agenda-branch"
$LastWrite = $Now.AddDays(-$Days)

$ROOT_DIRECTORY = "C:\inetpub\agenda-branch"
$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')

$appPool = "$normalizedBranchName"

$Logfilename = "C:\Users\teamcity\scripts\age-branch-cleaner.log"

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


$Folders = get-childitem -path $TargetFolder | 
Where {$_.psIsContainer -eq $true} | 
Where {$_.LastWriteTime -le "$LastWrite"} 

Write-output "##############################################" >> $Logfilename
write-output "Clean branch older than $Lastwrite" >> $Logfilename

# EACH FOLDER OLDER THAN XXX DAYS
foreach ($Folder in $Folders)
{
    $site = "Default Web site\age-branch\$Folder"
    Write-output "Sitename $site" >> $Logfilename
    # pause

    # REMOVE EACH APPLICATION INSIDE THE FOLDER-BRANCH
    foreach ($app in $apps)
    {
        Write-output "Deleting app $app" >> $Logfilename
        # Remove-WebApplication -Name $app -Site $site -ErrorAction Ignore
    }
    $appPool = $Folder.name
    
    # REMOVE EACH APPLICATION POOL OF THE FOLDER-BRANCH TO DELETE
    Write-output "Deleting app pool  $appPool"  >> $Logfilename
    # Remove-WebAppPool -Name $appPool -ErrorAction Ignore
    
    # REMOVE FOLDER
    write-output "Deleting folder $TargetFolder\$Folder" >> $Logfilename
    Write-output "----------------------------------------------" >> $Logfilename
    # Remove-Item $TargetFolder\$Folder -force -recurse -Confirm:$false -ErrorAction Ignore
}