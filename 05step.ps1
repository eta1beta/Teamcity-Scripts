function Trim-Length {
param (
    [parameter(Mandatory=$True,ValueFromPipeline=$True)] [string] $Str
  , [parameter(Mandatory=$True,Position=1)] [int] $Length
)
    $Str[0..($Length-1)] -join ""
}

$ROOT_DIRECTORY = "C:\inetpub\agenda-branch"

$branchName = "%teamcity.build.branch%"
$normalizedBranchName = $branchName.replace('/', '-')
$normalizedBranchName = $normalizedBranchName | Trim-Length 60

$installationPath = "$ROOT_DIRECTORY\$normalizedBranchName"

$apps = @{
    "Admissions\Admissions.csproj"                      = "Admissions";
    "Admissions.API\Admissions.API.csproj"              = "AdmissionsAPI";
    "Admissions.Referees\Admissions.Referees.csproj"    = "AdmissionsReferees";
    "Appointments\Appointments.csproj"                  = "Appointments";
    "ClickR\ClickR.csproj"                              = "ClickR";
    "Ldap.API\Ldap.API.csproj"                          = "Ldap.API";
    "Portal\Portal.csproj"                              = "Portal";
    "Portal.API\Portal.API.csproj"                      = "PortalAPI";
    "Portal.Widget\Portal.Widget.csproj"                = "PortalWidget";
    "Presences\Presences.csproj"                        = "Presences";
    "Presences.API\Presences.API.csproj"                = "PresencesAPI";
    "Presences.Public\Presences.Public.csproj"          = "Presences.Public";
    "Recognition\Recognition.csproj"                    = "Recognition";
    "Reports\Reports.csproj"                            = "Reports";
    "ResetPassword.API\ResetPassword.API.csproj"        = "ResetPasswordAPI";
    "ResetPassword.Web\ResetPassword.Web.csproj"        = "ResetPassword";
    "ValidatorFields\ValidatorFields.csproj"            = "ValidatorFields";
    "​Appointments.API\​Appointments.API.csproj"          = "​Appointments.API";
    "Calendars​\Calendars​.csproj"                        = "Calendars​";
}

foreach ($app in $apps.GetEnumerator()) {
    C:\Windows\Microsoft.NET\Framework64\v4.0.30319\MSBuild.exe `
        "dev\Agenda\$($app.Name)" `
        /p:Configuration=Release `
        /p:DeployOnBuild=true `
        /p:PublishProfile=TeamCity `
        /p:publishUrl="$installationPath\$($app.Value)"
    if (-Not $?) { exit 1 }
}