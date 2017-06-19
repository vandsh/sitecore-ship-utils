function Invoke-MultipartFormDataUpload
{
    [CmdletBinding()]
    PARAM
    (
        [string][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$InFile,
        [string]$ContentType,
        [Uri][parameter(Mandatory = $true)][ValidateNotNullOrEmpty()]$Uri,
        [System.Management.Automation.PSCredential]$Credential,
		[int]$Timeout
    )
    BEGIN
    {
        if (-not (Test-Path $InFile))
        {
            $errorMessage = ("File {0} missing or unable to read." -f $InFile)
            $exception =  New-Object System.Exception $errorMessage
			$errorRecord = New-Object System.Management.Automation.ErrorRecord $exception, 'MultipartFormDataUpload', ([System.Management.Automation.ErrorCategory]::InvalidArgument), $InFile
			$PSCmdlet.ThrowTerminatingError($errorRecord)
        }
 
        if (-not $ContentType)
        {
            Add-Type -AssemblyName System.Web
 
            $mimeType = [System.Web.MimeMapping]::GetMimeMapping($InFile)
            
            if ($mimeType)
            {
                $ContentType = $mimeType
            }
            else
            {
                $ContentType = "application/octet-stream"
            }
        }
    }
    PROCESS
    {
        Add-Type -AssemblyName System.Net.Http
 
		$httpClientHandler = New-Object System.Net.Http.HttpClientHandler
 
        if ($Credential)
        {
		    $networkCredential = New-Object System.Net.NetworkCredential @($Credential.UserName, $Credential.Password)
		    $httpClientHandler.Credentials = $networkCredential
        }
 
        $httpClient = New-Object System.Net.Http.Httpclient $httpClientHandler
		if($Timeout)
		{
			$httpClient.Timeout = New-Object TimeSpan(0, 0, $Timeout);
		}
        $packageFileStream = New-Object System.IO.FileStream @($InFile, [System.IO.FileMode]::Open)
        
		$contentDispositionHeaderValue = New-Object System.Net.Http.Headers.ContentDispositionHeaderValue "form-data"
	    $contentDispositionHeaderValue.Name = "fileData"
		$contentDispositionHeaderValue.FileName = (Split-Path $InFile -leaf)
 
        $streamContent = New-Object System.Net.Http.StreamContent $packageFileStream
        $streamContent.Headers.ContentDisposition = $contentDispositionHeaderValue
        $streamContent.Headers.ContentType = New-Object System.Net.Http.Headers.MediaTypeHeaderValue $ContentType
        
        $content = New-Object System.Net.Http.MultipartFormDataContent
        $content.Add($streamContent)
 
        try
        {
			$response = $httpClient.PostAsync($Uri, $content).Result
 
			if (!$response.IsSuccessStatusCode)
			{
				$responseBody = $response.Content.ReadAsStringAsync().Result
				$errorMessage = "Status code {0}. Reason {1}. Server reported the following message: {2}." -f $response.StatusCode, $response.ReasonPhrase, $responseBody
 
				throw [System.Net.Http.HttpRequestException] $errorMessage
			}
 
			return $response.Content.ReadAsStringAsync().Result
        }
        catch [Exception]
        {
			$PSCmdlet.ThrowTerminatingError($_)
        }
        finally
        {
            if($null -ne $httpClient)
            {
                $httpClient.Dispose()
            }
 
            if($null -ne $response)
            {
                $response.Dispose()
            }
        }
    }
    END { }
}