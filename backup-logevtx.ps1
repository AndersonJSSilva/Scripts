#(Get-EventLog -LogName Security).count
$source = $Target = ""
$env:COMPUTERNAME

$server = $env:COMPUTERNAME
[string]$data = get-date -Format dd-MM-yyyy
$timestamp = ((Get-Date).ToString('HHmmss_')+$data)
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"  
$backupfolder = "C:\BKP_EVTx\"
$uploadfolder = "\\arqprd01\backup_log$\"

if(Test-Path $backupfolder){ New-Item $backupfolder -ItemType directory}

$evtlog = Get-WmiObject -Class win32_NTEventlogfile | Where-Object {$_.LogfileName -eq "Security"}
$Filepath = $backupfolder+"{0}_{1}.evtx" -f $evtlog.LogfileName,$timestamp
#$result = ($evtlog.BackupEventlog($Filepath)).returnValue
$result = ($evtlog.ClearEventlog($Filepath)).returnValue
if($result -eq '0')
{
    Write-Host "backup efetuado"
    $fileevtx = Get-ChildItem -Path $backupfolder -include "*$timestamp.evtx" -Recurse
    if($fileevtx)
    {
        $source = $fileevtx.FullName
        $Target = $backupfolder+$fileevtx.BaseName+".zip"
        sz a -mx=9 $target $Source
    }
    if(Test-Path $Target)
{
   if(!(Test-Path $uploadfolder$server))
   {
        New-Item $uploadfolder$server -ItemType directory
        if(!(Test-Path $uploadfolder$server"\"$data))
        {
            New-Item $uploadfolder$server"\"$data -ItemType directory
        }
   }   
   $dest = $uploadfolder+$server+'\'+$data+'\'+$fileevtx.baseName+".zip"
   Copy-Item $target -Destination $dest
   if(Test-Path $dest)
   {
        Remove-Item $Target -Force
        Remove-Item $fileevtx.FullName -Force
   }
}
}


