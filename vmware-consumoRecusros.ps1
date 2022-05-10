$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1


#relatorio de consumo recursos dos hosts 
$vmwarehosts = @()
$tmphosts = Get-vmHost 
foreach($tmphost in $tmphosts)
{
    
$esxi = new-object PSObject
    $evt=$null
    $datastores = $null
    $datastore = $null
    $evt = $tmphost | select Manufacturer,Model, ProcessorType,@{Label="Host";Expression={$_.name -replace ".unimedrj.root", ""} },@{Label="MemoryTotal";Expression={"{0:N2}" -f $_.MemoryTotalGB} },@{Label="MemoryFree";Expression={"{0:N2}" -f ($_.MemoryTotalGB - $_.MemoryUsageGB)} }, @{Label="MemoryUsage";Expression={"{0:N2}" -f (($_.MemoryUsageGB * 100)/$_.MemoryTotalGB)} }, @{Label="CPUUsage";Expression={"{0:N2}" -f (($_.CpuUsageMhz * 100)/$_.CpuTotalMhz)} } 

 
    $vms = $tmphost| Get-VM |?{$_.PowerState -ne "PoweredOff"}
    $esxi = new-object PSObject
    $esxi | add-member -type NoteProperty -Name "Manufacturer" -Value $evt.Manufacturer
    $esxi | add-member -type NoteProperty -Name "Model" -Value $evt.Model
    $esxi | add-member -type NoteProperty -Name "HostName" -Value $evt.host
    $esxi | add-member -type NoteProperty -Name "Memory" -Value $evt.MemoryTotal
    $esxi | add-member -type NoteProperty -Name "Memory Free" -Value $evt.MemoryFree
    $esxi | add-member -type NoteProperty -Name "Memory Usage %" -Value $evt.memoryusage
    $esxi | add-member -type NoteProperty -Name "CPU" -Value $evt.ProcessorType
    $esxi | add-member -type NoteProperty -Name "CPU Usage %" -Value $evt.cpuusage
    $esxi | add-member -type NoteProperty -Name "VMs" -Value $vms.Count
    $vmwarehosts += $esxi
}
$vmwarehosts | Out-GridView -Title "VMVCENTER HOSTS RESOURCES COMSUMPTION"
$vmwarehosts | Export-Csv -Path c:\temp\vmwarehstrel.csv
$vmwarehosts | ft -AutoSize


#relatorio de consumo recursos dos datastores
$vmwarehosts = @()
$dts = Get-Datastore -Name compellent* | sort name | select name,CapacityGB, @{Label="% Usage";Expression={"{0:N2}" -f (((($_.FreeSpaceGB * 100)/$_.CapacityGB)-100)*(-1))}}
$dts += Get-Datastore -name vnx*| sort name | select name,CapacityGB, @{Label="% Usage";Expression={"{0:N2}" -f (((($_.FreeSpaceGB * 100)/$_.CapacityGB)-100)*(-1))}} 
$dts += Get-Datastore -name emc*| sort name | select name,CapacityGB, @{Label="% Usage";Expression={"{0:N2}" -f (((($_.FreeSpaceGB * 100)/$_.CapacityGB)-100)*(-1))}}

foreach ($dt in $dts)
{
    $esxi = new-object PSObject
    $esxi | add-member -type NoteProperty -Name "Datastore" -Value $dt.name
    $esxi | add-member -type NoteProperty -Name "Size" -Value $dt.capacityGB
    $esxi | add-member -type NoteProperty -Name "% usage" -Value $dt.'% Usage'
    $vmwarehosts += $esxi
}
$vmwarehosts |  Out-GridView -Title "VMVCENTER DATASTORE RESOURCES COMSUMPTION"
$vmwarehosts | Export-Csv -Path c:\temp\vmwaredtsrel.csv


$from = "vmware@unimedrio.com.br"
$to = "jean.rosseto@unimedrio.com.br"
$assunto = "Unimed Rio - VMWARE - Consumo de Recursos"
$corpo = "`n`nRelatório de consumo de recursos VMWARE (Hosts e Datastore)"

Send-MailMessage -to $to -from $from  -subject $assunto -SmtpServer mail.unimedrio.com.br -Body $corpo -Attachments c:\temp\vmwaredtsrel.csv,c:\temp\vmwarehstrel.csv

