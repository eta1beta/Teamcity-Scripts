import-module webadministration

$ROOT_DIRECTORY = "C:\inetpub\agenda-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')

$site = "Default Web site\age-branch\$normalizedBranchName"
$appPool = "age-$normalizedBranchName"

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