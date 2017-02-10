<#
    This function "smart" publishes the specified Sitecore target to the given $SiteUrl.
    It uses cURL (http://curl.haxx.se/) to post a request to a Sitecore website which has Sitecore Ship installed.
    Example usage: 
    .\publish-sitecorepackage.ps1 mysite.dev "preview,web" "smart" 60 300
#>

Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$SiteUrl,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$PublishTargets = "preview,web",
	[Parameter(Position=2, Mandatory=$false)]
    [string]$PublishMode = "smart",
    [Parameter(Position=3)]
    [ValidateRange(0, 99999)]
    [int]$ConnectionTimeOutInSeconds = 300,
    [Parameter(Position=4)]
    [ValidateRange(0, 99999)]
    [int]$MaxTimeOutInSeconds = 900

)

$fileUploadUrl = "$SiteUrl/services/publish/$PublishMode"
$curlPath = .$PSScriptRoot\get-curlpath.ps1
$curlCommand= "$curlPath -sS -fail --connect-timeout $ConnectionTimeOutInSeconds --max-time $MaxTimeOutInSeconds -X POST --form ""targets=$PublishTargets"" $fileUploadUrl"

Write-Output "INFO: Starting Invoke-Expression: $curlCommand"

Invoke-Expression $curlCommand