<#
    This function uploads & installs the specified Sitecore update package to the given $SiteUrl.
    Example usage:
    .\deploy-sitecorepackage.ps1 mysite.dev "C:\Project\Build\Artifacts\1-mysite-templates.update" 300 MyUsername MyPassword
	.\deploy-sitecorepackage.ps1 mysite.dev "C:\Project\Build\Artifacts\1-mysite-templates.update" 300 -ResultsOutputPath "c:/temp/ids.txt"
#>

Param(
    [Parameter(Position=0, Mandatory=$true)]
    [string]$SiteUrl,
    [Parameter(Position=1, Mandatory=$true)]
    [string]$UpdatePackagePath,
    [Parameter(Position=2)]
    [ValidateRange(0, 99999)]
    [int]$ConnectionTimeOutInSeconds = 300,
	[Parameter(Position=3)]
    [string]$Username,
	[Parameter(Position=4)]
    [string]$Password,
	[Parameter(Position=5)]
    [string]$ResultsOutputPath
)
."$PSScriptRoot\multipartFormDataUpload.ps1"
$fileUploadUrl = "$SiteUrl/services/package/install/fileupload"



if($Username){
	$secpasswd = ConvertTo-SecureString $Password -AsPlainText -Force
	$mycreds = New-Object System.Management.Automation.PSCredential ($Username, $secpasswd)
	Write-Host "POST Fileupload with credentials" -foregroundcolor green
	$shipResponse = Invoke-MultipartFormDataUpload -InFile $UpdatePackagePath -Uri $fileUploadUrl -Timeout $ConnectionTimeOutInSeconds -Credential $mycreds | ConvertFrom-Json
}
else{
	Write-Host "POST Fileupload" -foregroundcolor green
	$shipResponse = Invoke-MultipartFormDataUpload -InFile $UpdatePackagePath -Uri $fileUploadUrl -Timeout $ConnectionTimeOutInSeconds  | ConvertFrom-Json
}

$shipEntries = $shipResponse.Entries
$items = New-Object System.Collections.Generic.List[string]
$shipEntries | 
	ForEach-Object {
		if($_.ID -ne $null)
		{
			Write-Host $_.ID -foregroundcolor cyan
			$items.Add($_.ID)
		}
	}
	
if($ResultsOutputPath -ne $null)
{
	$items  | out-file $ResultsOutputPath
}