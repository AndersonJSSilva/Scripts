$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP
Disconnect-VIServer -Confirm:$false

########################################################################################################
### lun id for RDM disks
$vmdisks = @()
$vm = "crmgtwprd01"
$Disks = Get-VM -name $vm  | Get-HardDisk -DiskType "RawPhysical","RawVirtual"
Foreach ($Disk in $Disks)
{ 
  $diskinfo = new-object PSObject
  $diskinfo  | add-member -type NoteProperty -Name "VM Name" -Value $disk.parent
  $diskinfo  | add-member -type NoteProperty -Name "Disk Name" -Value $disk.name
  $diskinfo  | add-member -type NoteProperty -Name "Disk Type" -Value $disk.DiskType
  $diskinfo  | add-member -type NoteProperty -Name "File Name" -Value $disk.filename
  $diskinfo  | add-member -type NoteProperty -Name "Capacity GB" -Value $disk.capacitygb
  $diskinfo  | add-member -type NoteProperty -Name "Scsi Canonical Name" -Value $disk.ScsiCanonicalName
  $diskinfo  | add-member -type NoteProperty -Name "Device Name" -Value $disk.deviceName
  $Lun = Get-SCSILun $Disk.SCSICanonicalName -VMHost (Get-VM -name $vm).VMHost
  $diskinfo  | add-member -type NoteProperty -Name "LUN Id" -Value $Lun.RuntimeName.Substring($Lun.RuntimeName.LastIndexof(“L”)+1)
  $vmdisks += $diskinfo
  
}
$vmdisks

########################################################################################################

get-vm | get-snapshot | ft vm,name,Created,  @{Label="SizeMB";Expression={"{0:N2}" -f ($_.sizemb)}}

get-vm -Name vmbkpprd01 | Get-HardDisk

Get-VM | Get-VMResourceConfiguration  | where {$_.MemReservationMB -ne '0'} | select * | ft vm,cpureservationmhz,memreservationmb
Get-VM -Name polndev01 | Get-VMResourceConfiguration | where {$_.MemReservationMB -ne '0'} | Set-VMResourceConfiguration -MemReservationMB 0

$snapshots = get-vm | get-snapshot
$snapshots | ft vm,name,Created,  @{Label="SizeMB";Expression={"{0:N2}" -f ($_.sizemb)}}
#foreach($snapshot in $snapshots) {Remove-Snapshot -Snapshot $snapshot -RunAsync -Confirm:$true}
foreach($snapshot in $snapshots){if($snapshot.name -like "NBU_SNAPSHOT*"){Remove-Snapshot -Snapshot $snapshot -RunAsync -Confirm:$false}}

Get-Task | select Name,State,starttime,finishtime, @{Label="VM Name";Expression={Get-Vm -Id $_.objectid | select name}}

#busca maquinas que precisam de consolidação
Get-VM|?{((get-harddisk $_).count*2)*((get-snapshot -vm $_).count + 1) -lt ($_.extensiondata.layoutex.file|?{$_.name -like "*vmdk"}).count}

#descricao dos hosts
Get-VMHost | Sort Name | Get-View  | select Name, 
@{N=“Type“;E={$_.Hardware.SystemInfo.Vendor+ “ “ + $_.Hardware.SystemInfo.Model}},
@{N=“CPU“;E={$_.Hardware.CpuPkg[0].Description }},
@{N=“CPU DETAILS“;E={“PROC:“ + $_.Hardware.CpuInfo.NumCpuPackages + “ CORES:“ + $_.Hardware.CpuInfo.NumCpuCores + " THREADS:" + $_.Hardware.CpuInfo.NumCpuThreads}},
@{N=“MEM (GB)“;E={“” + [math]::round($_.Hardware.MemorySize / 1GB, 0)}},
@{N=“Version“;E={$_.Config.Product.FullName}} | Export-Csv c:\temp\hostinfo.csv
#############################################################

Get-VMHost | Sort Name | select *


#busca máquinas que precisam de consolidação e consolida
Get-VM | Where-Object {$_.Extensiondata.Runtime.ConsolidationNeeded} |
ForEach-Object {
  $_.ExtensionData.ConsolidateVMDisks()
}


$dts = Get-Datastore | ?{$_.name -like "*compellent"}
$dts.DatastoreBrowserPath
Get-vmHost

#Datastores % de uso
Get-Datastore | sort name | format-table name, @{Label="% Usage";Expression={"{0:N2}" -f (((($_.FreeSpaceGB * 100)/$_.CapacityGB)-100)*(-1))}} -AutoSize
#Memoria e CPU % de uso
Get-vmHost | sort name | format-table @{Label="Host";Expression={$_.name -replace ".unimedrj.root", ""} }, @{Label="% Memory Usage";Expression={"{0:N2}" -f (($_.MemoryUsageGB * 100)/$_.MemoryTotalGB)} }, @{Label="% CPU Usage";Expression={"{0:N2}" -f (($_.CpuUsageMhz * 100)/$_.CpuTotalMhz)} } -AutoSize
#Memoria Livre nos Hosts
Get-vmHost | sort name | format-table @{Label="Host";Expression={$_.name -replace ".unimedrj.root", ""} }, @{Label="Memory Free";Expression={"{0:N2}" -f ($_.MemoryTotalGB - $_.MemoryUsageGB) }} -AutoSize

#relatorio de consumo recursos dos hosts e datastore interno
$vmwarehosts = @()
$tmphosts = Get-vmHost #-Name esxsieprd01.unimedrj.root
foreach($tmphost in $tmphosts)
{
    
$esxi = new-object PSObject
    $evt=$null
    $datastores = $null
    $datastore = $null
    $evt = $tmphost | select @{Label="Host";Expression={$_.name -replace ".unimedrj.root", ""} }, @{Label="MemoryUsage";Expression={"{0:N2}" -f (($_.MemoryUsageGB * 100)/$_.MemoryTotalGB)} }, @{Label="CPUUsage";Expression={"{0:N2}" -f (($_.CpuUsageMhz * 100)/$_.CpuTotalMhz)} } 
    $datastores = $tmphost | Get-Datastore 
    foreach($datastore in $datastores)
    {
       if (($datastore.CapacityGB -lt 1100) -and ($datastore.Name -notlike "*vnx*"))
        {
            $dts = Get-Datastore $datastore.Name | select name, @{Label="datastoreUsage";Expression={"{0:N2}" -f (((($_.FreeSpaceGB * 100)/$_.CapacityGB)-100)*(-1))}} 
        }
    }
    $esxi = new-object PSObject
    $esxi | add-member -type NoteProperty -Name "HostName" -Value $evt.host
    $esxi | add-member -type NoteProperty -Name "Memory Usage %" -Value $evt.memoryusage
    $esxi | add-member -type NoteProperty -Name "CPU Usage %" -Value $evt.cpuusage
    $esxi | add-member -type NoteProperty -Name "Datastore Name" -Value $dts.Name
    $esxi | add-member -type NoteProperty -Name "Datastore Usage %" -Value $dts.datastoreUsage
    $vmwarehosts += $esxi
}
$vmwarehosts |  Out-GridView -Title "VMVCENTER HOSTS RESOURCES COMSUMPTION"


#qtd de vms datacenter barra e total de memoria das maquinas
$datacenter = "Unimed Rio - barra"
$soma = 0
$vms = Get-Datacenter -Name $datacenter | Get-VM
write-host "total de VMS: "$vms.count
foreach($vm in $vms){

$soma+=$vm.memorygb

}
write-host "total de RAM (GB) das VMs: " $soma
$soma = 0
$hosts = Get-Datacenter -Name $datacenter | Get-VMHost
foreach($server in $hosts){

$soma+=$server.MemoryTotalGB

}
write-host "total de RAM (GB) dos hosts: " $soma
##################################################################


Get-VMHostNetworkAdapter | FT VMhost, Name, IP, SubnetMask, Mac, PortGroupName, vMotionEnabled, mtu, FullDuplex, BitRatePerSec 

#register VM
$VMXFile = "[datastore-emc] SERVER01/SERVER01.vmx"
$ESXHost = "esxiprd23.unimedrj.root"
New-VM -VMFilePath $VMXFile -VMHost $ESXHost

#remove from invetory
Remove-VM -VM "vmtoremove"

$temp = get-vm crmgtwprd02
$temp

Get-VM -Name bkp_SCCMPRD01 |
Add-Member -MemberType ScriptProperty -Name 'VMXPath' -Value {$this.extensiondata.config.files.vmpathname} -Passthru -Force | 
Select-Object Name,VMXPath

##################################################################################
$datainicio = get-date -Day 14 -Month 8 -Year 2014 -Hour 00 -Minute 00 -Second 00
$datafim = get-date -Day 14 -Month 8 -Year 2014 -Hour 23 -Minute 59 -Second 00
$events = Get-VIEvent -Start $datainicio -Finish $datafim 
foreach($event in $events)
{   
    if ($event.EventTypeId -like "esx.problem.scsi.device.io.latency.high")
    {
        $event | fl createdtime, eventtypeid, fullformattedmessage        
    }
}
##################################################################################


$tasks = Get-Task | ?{$_.state -like "*run*"}
get-datacenter -Name "Unimed Rio - Barra" | Get-VIEvent | ft FullFormattedMessage, CreatedTime, @{Label="Datacenter";Expression={$_.name}}
Get-VM -name domprd01 | Get-VIEvent | ft FullFormattedMessage, CreatedTime, @{Label="Datacenter";Expression={$_.name}}
get-datacenter -Name "Unimed Rio - Benfica" | get-vm | Get-VIEvent


##########################################################################

$vms = get-datacenter -Name "Unimed rio - barra" |
Get-datastore -name "datastore-compellent" |
get-vmhost esxiprd24.unimedrj.root | get-vm | ?{($_.PowerState -ne "PoweredOff")} | Sort-Object -Property Name
$vms.Length
get-vm -name rtcprd01 | Shutdown-VMGuest -Confirm:$false

###################################################################################
New-VIProperty -Name lunDatastoreName -ObjectType ScsiLun -Value {
    param($lun)
 
    $ds = $lun.VMHost.ExtensionData.Datastore | %{Get-View $_} | `
        where {$_.Summary.Type -eq "VMFS" -and
            ($_.Info.Vmfs.Extent | where {$_.DiskName -eq $lun.CanonicalName})}
    if($ds)
    {
        $ds.Name
    }
} -Force | Out-Null

Get-VMHost -Name esxiprd22.unimedrj.root | Get-ScsiLun | Select CanonicalName, CapacityGB, lunDatastoreName
##################################################################################
$dts = Get-VMHost -Name esxiprd09.unimedrj.root | Get-Datastore
ForEach($dt in $dts)
{
    if ($dt)
    {
        $dt.ExtensionData.Info.Vmfs.Extent | Select-Object -Property @{Name="Name";Expression={$dt.Name}},DiskName
    }
}
##################################################################################

get-vm | %{write-host $_.name;get-networkadapter -VM $_.name | ?{$_.type -eq "Flexible"}}

get-vm logprd01|get-networkadapter|set-networkadapter -type e1000
get-vm -name opmedev01 |get-networkadapter|set-networkadapter -type e1000

############################

get-vm | ?{$_.name -like "windows10*"} | % {$_ | Shutdown-VMGuest -Confirm:$true}

get-vm -Name agov0* | Start-VM -Confirm:$false

Get-VirtualSwitch | ft vmhost,name,@{l="Portas Usadas";e={$_.numports-$_.numportsavailable}}


######### criar vm portgroup ########
Get-VMHost -Name esxiprd23.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.8.x" -VLanId 8
Get-VMHost -Name esxiprd23.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.100.x" -VLanId 100
Get-VMHost -Name esxiprd23.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.102.x" -VLanId 102
Get-VMHost -Name esxiprd23.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.5.x" -VLanId 5
Get-VMHost -Name esxiprd23.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.85.x" -VLanId 185
Get-VMHost -Name esxiprd23.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.88.x" -VLanId 188
#####################################
Get-VMHost -Name esxiprd22.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | Get-VirtualPortGroup | select name, vlanid 


Get-VMHost -Name esxiprd16.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Virtual Machine Network 2"


Move-VM -vm opmetst01 -Destination esxiprd16.unimedrj.root -RunAsync

<#
Get-VMHost esxiprd08.unimedrj.root | Get-Datastore
New-PSDrive -Name "mounteddatastore" -Root \ -PSProvider VimDatastore -Datastore (Get-Datastore "datastore-08")
Set-Location mounteddatastore:
Set-Location -Path C:\
Get-PSDrive -Name mounteddatastore
Get-VMHost esxiprd08.unimedrj.root | Get-AdvancedSetting -Name "ScratchConfig.ConfiguredScratchLocation" | select name,value
Get-VMHost esxiprd08.unimedrj.root | Get-AdvancedSetting -Name "ScratchConfig.ConfiguredScratchLocation" | Set-AdvancedSetting -Value "/vmfs/volumes/datastore-08/.locker-esxiprd08"
#>

get-vm -name os* | Select Name, @{Label="ProvisionedSpaceGB";Expression={"{0:N2}" -f ($_.ProvisionedSpaceGB)}},  @{Label="UsedSpaceGB";Expression={"{0:N2}" -f ($_.UsedSpaceGB)}}, @{Label="Datastore";Expression={get-datastore -id $_.DatastoreIdList[0]}}

Get-VMEVCMode -Cluster_str cluster-m620
function Get-VMEVCMode {
    param(
        [string]$Cluster_str = ".+"
    )
 
    process {
        ## get the matching cluster View objects
        Get-View -ViewType ClusterComputeResource -Property Name,Summary -Filter @{"Name" = $Cluster_str} | Foreach-Object {
            $viewThisCluster = $_
            ## get the VMs Views in this cluster
            Get-View -ViewType VirtualMachine -Property Name,Runtime.PowerState,Summary.Runtime.MinRequiredEVCModeKey -SearchRoot $viewThisCluster.MoRef | Foreach-Object {
                ## create new PSObject with some nice info
                New-Object -Type PSObject -Property ([ordered]@{
                    Name = $_.Name
                    PowerState = $_.Runtime.PowerState
                    VMEVCMode = $_.Summary.Runtime.MinRequiredEVCModeKey
                    ClusterEVCMode = $viewThisCluster.Summary.CurrentEVCModeKey
                    ClusterName = $viewThisCluster.Name
                })
            }
        }
    }
}


$computers = $null
$computers = @()
Get-Datacenter -name "Unimed Rio - Benfica" | get-vm | ?{($_.PowerState -eq "PoweredOn") -and ($_.name -notlike "DCBEN*")} | %{$computers += $_.name}

$maquinas

$DnsAddress = "10.200.100.61","10.200.100.60"
$DnsAddress = "10.101.52.61","10.101.52.60"

Get-VMHostNetwork -VMHost esxiprd20.unimedrj.root | Set-VMHostNetwork -DomainName "unimedrj.root"
Get-VMHost | Get-VMHostNetwork | Set-VMHostNetwork -DnsAddress $DnsAddress

#conta o num de vm por hosts dos DTCs virtuais
$dtcs = Get-Datacenter
foreach($dtc in $dtcs)
{

    $dtc.name
    $vmhosts = $dtc | Get-VMHost | Sort-Object name
    foreach($vmhost in $vmhosts)
    {
        Write-Host $vmhost.name -foregroundColor Yellow
        $vmson = $vmhost | get-vm  | ?{$_.PowerState -eq "poweredon"}
        $vmsoff = $vmhost | get-vm | ?{$_.PowerState -eq "poweredoff"}
        Write-Host "VMs ligadas: "$vmson.Length -foregroundColor red
        Write-Host "VMs desligadas: "$vmsoff.Length -foregroundColor red
    }
    $vmhosts = $vmson = $vmsoff = $null

}
#######################################################################


$vms620 = Get-Cluster "Cluster-m620" | get-vm | Select Name, @{Label="UsedSpaceGB";Expression={"{0:N2}" -f ($_.UsedSpaceGB)}}, @{Label="ProvisionedSpaceGB";Expression={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}
$vms620 | Export-Csv c:\temp\vmscluster620.csv -Encoding Unicode 
c:\temp\vmscluster620.csv

$vms610 = Get-Cluster "Cluster-m610*" | get-vm | Select Name, @{Label="UsedSpaceGB";Expression={"{0:N2}" -f ($_.UsedSpaceGB)}}, @{Label="ProvisionedSpaceGB";Expression={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}
$vms610 | Export-Csv c:\temp\vmscluster610.csv -Encoding Unicode 
c:\temp\vmscluster610.csv

$vms09 = Get-vmhost "esxiprd09*" | get-vm | Select Name, @{Label="UsedSpaceGB";Expression={"{0:N2}" -f ($_.UsedSpaceGB)}}, @{Label="ProvisionedSpaceGB";Expression={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}
$vms09 | Export-Csv c:\temp\vms09.csv -Encoding Unicode 
c:\temp\vms09.csv

$vms10 = Get-vmhost "esxiprd10*" | get-vm | Select Name, @{Label="UsedSpaceGB";Expression={"{0:N2}" -f ($_.UsedSpaceGB)}}, @{Label="ProvisionedSpaceGB";Expression={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}
$vms10 | Export-Csv c:\temp\vms10.csv -Encoding Unicode 
c:\temp\vms10.csv


###### memória livre no cluster########
function Get-MemoryFreefromCluster
{
        param(
        [string]$ClusterName = ".+"
    )

$vmwarehosts   = @()
$totalmemoryfree = $null
$esxihosts = Get-Cluster $ClusterName | Get-vmHost | sort name | select @{Label="Host";Expression={$_.name -replace ".unimedrj.root", ""} }, @{Label="FreeMemory";Expression={"{0:N0}" -f ($_.MemoryTotalGB - $_.MemoryUsageGB)} }
foreach($server in $esxihosts)
{
    $esxi = new-object PSObject
    $esxi | add-member -type NoteProperty -Name "HostName" -Value $server.host
    $esxi | add-member -type NoteProperty -Name "FreeMemory" -Value $server.FreeMemory
    $vmwarehosts += $esxi
}
$vmwarehosts | %{[Int32]$totalmemoryfree += [convert]::ToInt32($_.FreeMemory,10) }
$totalmemoryfree
}
Get-MemoryFreefromCluster -ClusterName Cluster-m620