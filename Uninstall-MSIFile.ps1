function Uninstall-MSIFile {

[CmdletBinding()]
Param(
[parameter(mandatory=$true,ValueFromPipeline=$true,ValueFromPipelinebyPropertyName=$true)]
[ValidateNotNullorEmpty()]
[string]$msiFile
)
if (!(Test-Path $msiFile)){
throw "Path to the MSI File $($msiFile) is invalid. Please supply a valid MSI file"
}
$arguments = @(
"/x"
"`"$msiFile`""
"/qn"
"/norestart"
)
Write-Verbose "Uninstalling $msiFile....."
$process = Start-Process -FilePath msiexec.exe -ArgumentList $arguments -Wait -PassThru
if ($process.ExitCode -eq 0){
Write-Verbose "$msiFile has been successfully uninstalled"
}
else {
Write-Error "installer exit code  $($process.ExitCode) for file  $($msifile)"
}
}
