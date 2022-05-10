function Get-ComputerStats {
  param(
    [Parameter(Mandatory=$true, Position=0, 
               ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNull()]
    [string[]]$ComputerName
  )

  process {
    foreach ($c in $ComputerName) {
        $avg = Get-WmiObject win32_processor -computername $c | 
                   Measure-Object -property LoadPercentage -Average | 
                   Foreach {$_.Average}
        $mem = Get-WmiObject win32_operatingsystem -ComputerName $c |
                   Foreach {"{0:N0}" -f ((($_.TotalVisibleMemorySize - $_.FreePhysicalMemory)*100)/ $_.TotalVisibleMemorySize)}
        
        [int]$diskTotal = (Get-WmiObject Win32_LogicalDisk -ComputerName $c -Filter drivetype=3 |  Foreach {("{0:N0}" -f ((($_.size)/1024/1024)/1024))} | Measure-Object -Sum).sum 
        
        [int]$free = (Get-WmiObject Win32_LogicalDisk -ComputerName $c -Filter drivetype=3 | Foreach {$_.driveletter + ("{0:N0}" -f ((($_.FreeSpace)/1024/1024)/1024))} | Measure-Object -Sum).sum 

        $percentfree = ("{0:N0}" -f (($free / $disktotal)*100))
        
        new-object psobject -prop @{ # Work on PowerShell V2 and below
        # [pscustomobject] [ordered] @{ # Only if on PowerShell V3
            ComputerName = $c
            AverageCpu = $avg
            MemoryUsage = $mem
            DisksSize = $diskTotal
            PercentFree = $percentfree
        }
    }
  }
  }

  

$ArrComputers =  Get-Content -Path c:\temp\listaservers.txt

$ArrComputers =  "neobarprd01","neobarprd02","neobarprd03","neopdoprd01","neopdoprd02","casprd01", "casprd02", "boxprd01","boxprd02"
$ArrComputers +=  "crmserprd01","crmeaiprd01","crmeaiprd02","crmaomprd01","crmaomprd02"
$ArrComputers +=  "sasprd01","faxdbprd02","webdev01","webprd01","webprd02","spoappprd01","spodbprd01","polnappprd04","polnappprd05"


$output = @()

Clear-Host
foreach ($Computer in $ArrComputers) 
{
    if((Test-Connection -ComputerName $Computer) -and (Test-Path "\\$Computer\c$\windows\") ){
    
    $computerSystem = get-wmiobject Win32_ComputerSystem -Computer $Computer
    #$computerBIOS = get-wmiobject Win32_BIOS -Computer $Computer
    $computerOS = get-wmiobject Win32_OperatingSystem -Computer $Computer
    $computerCPU = get-wmiobject Win32_Processor -Computer $Computer
    [array]$computerCPUCore = get-wmiobject Win32_Processor -Computer $Computer
    if($computerCPU.Length -ne $null){$computerCPU = $computerCPU.Length.ToString() + " x " + $computerCPU[0].Name} else {$computerCPU = "1 x " + $computerCPU.Name}
    #$computerHDD = Get-WmiObject Win32_LogicalDisk -ComputerName $Computer -Filter drivetype=3
    $stats = Get-ComputerStats -ComputerName $Computer
    
  write-host "System Information for: " $computerSystem.Name -BackgroundColor DarkCyan
  $linha = new-object PSObject
  $linha  | add-member -type NoteProperty -Name "Hostname" -Value $computerSystem.Name
  $linha  | add-member -type NoteProperty -Name "CPU" -Value $computerCPU
  $linha  | add-member -type NoteProperty -Name "Core / CPU" -Value $computerCPUCore.NumberOfLogicalProcessors[0]
  $linha  | add-member -type NoteProperty -Name "RAM (GB)" -Value ("{0:N2}" -f ($computerSystem.TotalPhysicalMemory/1GB))
  $linha  | add-member -type NoteProperty -Name "Operating System" -Value ($computerOS.caption + ", Service Pack: " + $computerOS.ServicePackMajorVersion)
  $linha  | add-member -type NoteProperty -Name "Disco (Total GB)" -Value $stats.DisksSize
  $linha  | add-member -type NoteProperty -Name "Uso de CPU (Média)" -Value $stats.AverageCpu
  $linha  | add-member -type NoteProperty -Name "Uso de Disco (% Livre)" -Value $stats.PercentFree
  $linha  | add-member -type NoteProperty -Name "Uso de Memória (% Usada)" -Value $stats.MemoryUsage
  $output += $linha

        
        
        
        
        }


        
}

$output #| export-csv c:\temp\vms.csv -Encoding Unicode

