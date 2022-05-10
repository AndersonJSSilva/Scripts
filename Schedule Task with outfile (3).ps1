function Get-AllTaskSubFolders {
    [cmdletbinding()]
    param (
        $FolderRef = $Schedule.getfolder("\")
    )
    if ($RootFolder)
    {
        $FolderRef
    } else {

        $FolderRef
        $ArrFolders = @()
    
        try { 
               if(($folders = $folderRef.getfolders(1)))
        {
            foreach ($folder in $folders)
            {
                $ArrFolders += $folder
                if($folder.getfolders(1))
                {
                    Get-AllTaskSubFolders -FolderRef $folder
                }
            }
        }
        } catch {} 

        $ArrFolders
    }
}


try {
       $schedule = new-object -com("Schedule.Service") 
} catch {
       Write-Warning "Schedule.Service COM Object not found, this script requires this object"
       return
}


$saidatask = ""
$hostnames = Get-Content C:\SERVERS\servidores_HMG.txt
foreach($ComputerName in $hostnames ){

try{$Schedule.connect($ComputerName)} catch {}
$AllFolders = Get-AllTaskSubFolders

foreach ($Folder in $AllFolders) {
    if (($Tasks = $Folder.GetTasks(0))) {
        $TASKS | % {[array]$results += $_}
        $Tasks | Foreach-Object {
                     
            if(([xml]$_.xml).Task.Principals.Principal.UserID -like "*adm*")
            {
                
                $saidatask +="`n"+$ComputerName + "`t" +$_.path+ "`t`t"+ ([xml]$_.xml).Task.Principals.Principal.UserID
            }
            
        }
    }
} 

} 
Set-Content -Path C:\SERVERS\resultTASK_HMG.txt -Value $saidatask