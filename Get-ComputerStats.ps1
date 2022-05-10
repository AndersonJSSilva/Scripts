function Get-ComputerStats {
  param(
    [Parameter(Mandatory=$true, Position=0, 
               ValueFromPipeline=$true, ValueFromPipelineByPropertyName=$true)]
    [ValidateNotNull()]
    [string[]]$ComputerName
  )

  process {
      foreach ($c in $ComputerName)
      {
        $ram = gwmi win32_physicalmemory -ComputerName $c | Measure-Object -Property Capacity -Sum | % {((($_.Sum)/1024)/1024)/1024}
        $totalcores = gwmi win32_processor -computername $c| Measure-Object -Property NumberOfLogicalProcessors -Sum | Foreach {$_.Sum}
        $avg = Get-WmiObject win32_processor -computername $c | Measure-Object -property LoadPercentage -Average | Foreach {$_.Average}
        $disks = gwmi win32_logicaldisk -computer $c -filter "drivetype=3" | select @{Label="Used";Expression={ [math]::round(((($_.size - $_.freespace)/1024)/1024)/1024)}} | Measure-Object -Property Used -Sum | Foreach {$_.Sum}
        
        #new-object psobject -prop @{ # Work on PowerShell V2 and below
         [pscustomobject] [ordered] @{ # Only if on PowerShell V3
            ComputerName = $c
            TotalOfCPUCores = $totalcores
            AverageCpu = $avg
            TotalOfRam = ($ram).ToString() + " GB"
            DiskUsage = ($disks).ToString() + " GB"
        }
    }
  }
}


$servidores = @("crmserprd01","crmbipprd01","crmeaiprd01","crmeaiprd02","crmaomprd01","crmaomprd02")
$servidores = Get-Content C:\temp\sccm.txt
$servidores | Get-ComputerStats | ft *




