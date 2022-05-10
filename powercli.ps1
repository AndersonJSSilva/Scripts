$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1
Disconnect-VIServer -Confirm:$false

Connect-VIServer 10.100.1.250
Disconnect-VIServer -Confirm:$false

function Get-DatastoreByVM(){
$vms = get-vm
foreach($vm in $vms)
{

  $VMinfo = new-object PSObject
  $VMinfo  | add-member -type NoteProperty -Name "VM Name" -Value $vm.Name
  $VMinfo  | add-member -type NoteProperty -Name "DataStore Name" -Value (Get-Datastore -Id $vm.DatastoreIdList).Name
  $VMinfo 

}

}

Get-DatastoreByVM

get-vm | select  name, usedspaceGB

function get-RDMFromVM($vmname){
########################################################################################################
### lun id for RDM disks
$vmdisks = @()
$vm = $vmname
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
}
########################################################################################################
Get-VmwarePathStatus

get-RDMFromVM -vmname neodbhmg01

get-vm | get-snapshot | ft vm,name,Created,  @{Label="SizeMB";Expression={"{0:N2}" -f ($_.sizemb)}}

get-vm -Name vmbkpprd01 | Get-HardDisk

get-vmhost -name esxiprd24.unimedrj.root | get-vm | select name, powerstate

get-vm -Name fabrica005 | Get-HardDisk

Get-VM | Get-VMResourceConfiguration  | where {$_.MemReservationMB -ne '0'} | select * | ft vm,cpureservationmhz,memreservationmb
Get-VM -Name polndev01 | Get-VMResourceConfiguration | where {$_.MemReservationMB -ne '0'} | Set-VMResourceConfiguration -MemReservationMB 0

$snapshots = get-vm | get-snapshot
$snapshots | ft vm,name,Created,  @{Label="SizeMB";Expression={"{0:N2}" -f ($_.sizemb)}}
#foreach($snapshot in $snapshots) {Remove-Snapshot -Snapshot $snapshot -RunAsync -Confirm:$true}
foreach($snapshot in $snapshots){if($snapshot.name -like "snap*"){Remove-Snapshot -Snapshot $snapshot -RunAsync -Confirm:$false}}

$snapshots | Measure-Object -Average -Sum -Maximum -Minimum SizeMB 

$snapshots  | select vm,name,Created,  @{Label="SizeMB";Expression={($_.sizemb)}} | Sort-Object sizemb

$snapshots | ?{$_.name -like "deplo*"} | select vm,name,Created,  @{Label="SizeMB";Expression={"{0:N2}" -f ($_.sizemb)}} | Sort-Object vm

$hosts = Get-VMHost esxiprd
foreach($hst in $hosts)
{
    Get-VMHostHba -VMHost $hst -Type FibreChannel  | select vmhost, device,status, speed
}


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
#######################################################################################################################

Get-VMHost | Sort Name | select *


#busca máquinas que precisam de consolidação e consolida
Get-VM | Where-Object {$_.Extensiondata.Runtime.ConsolidationNeeded} |
ForEach-Object {
  $_.ExtensionData.ConsolidateVMDisks()
}


$dts = Get-Datastore | ?{$_.name -like "*compellent*"}
$dts.DatastoreBrowserPath
Get-vmHost

#Datastores % de uso
Get-Datastore | sort name | format-table name, @{Label="% Usage";Expression={"{0:N2}" -f (((($_.FreeSpaceGB * 100)/$_.CapacityGB)-100)*(-1))}} -AutoSize
#Memoria e CPU % de uso
Get-vmHost | sort name | format-table @{Label="Host";Expression={$_.name -replace ".unimedrj.root", ""} }, @{Label="% Memory Usage";Expression={"{0:N2}" -f (($_.MemoryUsageGB * 100)/$_.MemoryTotalGB)} }, @{Label="% CPU Usage";Expression={"{0:N2}" -f (($_.CpuUsageMhz * 100)/$_.CpuTotalMhz)} } -AutoSize
#Memoria Livre nos Hosts
Get-vmHost | sort name | format-table @{Label="Host";Expression={$_.name -replace ".unimedrj.root", ""} }, @{Label="Memory Free";Expression={"{0:N2}" -f ($_.MemoryTotalGB - $_.MemoryUsageGB) }} -AutoSize

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

Get-VMHost -Name esxiprd28.unimedrj.root | Get-ScsiLun | Select CanonicalName, CapacityGB, lunDatastoreName, RuntimeName 

Get-VMHost -Name esxiprd08.unimedrj.root | Get-ScsiLun | ft lunDatastoreName, CapacityGB, RuntimeName, model, vendor, CanonicalName -AutoSize
##################################################################################
$dts = Get-VMHost -Name esxiprd22.unimedrj.root | Get-Datastore
ForEach($dt in $dts)
{
    if ($dt)
    {
        $dt.ExtensionData.Info.Vmfs.Extent | Select-Object -Property @{Name="Name";Expression={$dt.Name}},DiskName
    }
}
##################################################################################

get-vm | %{write-host $_.name;get-networkadapter -VM $_.name | ?{$_.type -eq "Flexible"}}

get-vm -name fttestevm|get-networkadapter|set-networkadapter -type e1000
get-vm -name polndev02 |get-networkadapter|set-networkadapter -type e1000

get-vm -name polndev02 |get-networkadapter | select *
get-vm -name polndev02| select *

$vms = get-vmhost -name esxiprd28.unimedrj.root | get-vm  |%{get-networkadapter -VM $_.name | ?{$_.Type -eq "Flexible"}| select type, parentid}
foreach($vm in $vms)
{get-vm -Id $vm.parentid | select name}

############################

get-vm | ?{$_.name -like "windows10*"} | % {$_ | Shutdown-VMGuest -Confirm:$true}

get-vm -Name agov0* | Start-VM -Confirm:$false

Get-VirtualSwitch | ft vmhost,name,@{l="Portas Usadas";e={$_.numports-$_.numportsavailable}}


######### criar vm portgroup ########
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.8.x" -VLanId 8
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.100.x" -VLanId 100
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.102.x" -VLanId 102
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.104.x" -VLanId 104
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.106.x" -VLanId 106
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.108.x" -VLanId 108
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.5.x" -VLanId 5
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.85.x" -VLanId 185
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.88.x" -VLanId 188
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
#####################################

Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.8.x" -VLanId 8
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.100.x" -VLanId 100
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.102.x" -VLanId 102
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.104.x" -VLanId 104
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.106.x" -VLanId 106
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.108.x" -VLanId 108
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.5.x" -VLanId 5
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.85.x" -VLanId 185
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.88.x" -VLanId 188
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444


Get-VMHost -Name esxiprd08.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | Get-VirtualPortGroup | select name, vlanid 


Get-VMHost -Name esxiprd16.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Virtual Machine Network 2"


Get-VMHost -Name esxiprd22.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
Get-VMHost -Name esxiprd23.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
Get-VMHost -Name esxiprd24.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
Get-VMHost -Name esxiprd25.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
Get-VMHost -Name esxiprd26.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
Get-VMHost -Name esxiprd27.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
Get-VMHost -Name esxiprd28.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
Get-VMHost -Name esxiprd29.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444
Get-VMHost -Name esxiprd30.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Velox" -VLanId 444


Get-VirtualSwitch -Name "vswitch0" | Get-VirtualPortGroup -Name "Rede Out DSL" | Set-VirtualPortGroup -Name "Rede Out DSL" -VLanId 444

Get-Cluster cluster-m610* | Get-VMHost | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Out DSL" -VLanId 444
Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Client DSL" -VLanId 400
Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede Client HS" -VLanId 800

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

###### memória do cluster########
function Get-MemoryfromCluster
{
        param(
        [string]$ClusterName = ".+"
    )

$vmwarehosts   = @()
$totalmemoryfree = $null
$esxihosts = Get-Cluster $ClusterName | Get-vmHost | sort name | select @{Label="Host";Expression={$_.name -replace ".unimedrj.root", ""} }, @{Label="MemoryTotal";Expression={"{0:N0}" -f ($_.MemoryTotalGB)} }
foreach($server in $esxihosts)
{
    $esxi = new-object PSObject
    $esxi | add-member -type NoteProperty -Name "HostName" -Value $server.host
    $esxi | add-member -type NoteProperty -Name "MemoryTotal" -Value $server.MemoryTotal
    $vmwarehosts += $esxi
}
$vmwarehosts | %{[Int32]$totalmemoryfree += [convert]::ToInt32($_.MemoryTotal,10) }
$totalmemoryfree
}
Get-MemoryfromCluster -ClusterName Cluster-m620

########################lista vms de cada host
$saida = @()
$hosts = get-vmhost | Sort-Object name
foreach($server in $hosts)
{
    $saida += $server | get-vm | select vmhost,name
}
$saida | Export-Csv "\\arqprd01\suporte$\1.SUPORTE\Auditoria_Controle(Windows)\VMs_x_Hosts\VMhostxVMs.csv" -Encoding Unicode
##############################################################

Get-Datacenter -Name "Unimed Rio - Benfica" | get-vm | select name | Sort-Object name


Get-VM | Where-Object {$_.Version -eq 'v4'} | Sort-Object Name | Format-Table Name,Version -AutoSize

Get-VM | Where-Object {($_.name -like '*dsv*') -or ($_.name -like '*dev*')} | Sort-Object Name | select name, MemoryGB

Get-VMHost -name "esxiprd09*" | Get-VirtualPortGroup -Name "Rede 10.100.x.x" | Set-VirtualPortGroup -Name "Rede 10.100.85.x"
Get-VMHost -name "esxiprd10*" | Get-VirtualPortGroup -Name "Rede 10.100.x.x" | Set-VirtualPortGroup -Name "Rede 10.100.85.x"
Get-VMHost -name "esxiprd09*" | Get-VirtualPortGroup -Name "Rede 10.100.85.x" | Set-VirtualPortGroup -Name "Rede 10.100.x.x"


$OldNetwork = "SIEBEL_NLB" 
$NewNetwork = "Rede 10.200.85.x"
Get-VMHost -name "esxiprd11*" | Get-VirtualPortGroup -Name $OldNetwork | Set-VirtualPortGroup -Name $NewNetwork
Get-VMHost -name "esxiprd11*" | Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -NetworkName $NewNetwork -Confirm:$false
Get-VMHost -name "esxiprd12*" | Get-VirtualPortGroup -Name $OldNetwork | Set-VirtualPortGroup -Name $NewNetwork
Get-VMHost -name "esxiprd12*" | Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -NetworkName $NewNetwork -Confirm:$false


$OldNetwork = "Rede 10.200.85.x" 
$NewNetwork = "SIEBEL_NLB"
Get-VMHost -name "esxiprd11*" | Get-VirtualPortGroup -Name $OldNetwork | Set-VirtualPortGroup -Name $NewNetwork
Get-VMHost -name "esxiprd11*" | Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -NetworkName $NewNetwork -Confirm:$false
Get-VMHost -name "esxiprd12*" | Get-VirtualPortGroup -Name $OldNetwork | Set-VirtualPortGroup -Name $NewNetwork
Get-VMHost -name "esxiprd12*" | Get-VM |Get-NetworkAdapter |Where {$_.NetworkName -eq $OldNetwork } |Set-NetworkAdapter -NetworkName $NewNetwork -Confirm:$false

get-vm -name osappdsv01 | Shutdown-VMGuest

get-vm -name osappdsv01 | Set-VM -MemoryMB 8192

Get-VMHostFirmware -VMHost esxiprd20.unimedrj.root -BackupConfiguration -DestinationPath c:\temp\bkphost\

#To back up the configuration data for an ESXi host:
$hosts = Get-VMHost |?{$_.ConnectionState -eq "Connected"}
foreach($hst in $hosts)
{
    Get-VMHostFirmware -VMHost $hst.Name -BackupConfiguration -DestinationPath c:\temp\bkphost\
}
<#To restore
Note: When restoring configuration data, the build number of the host must match the build number of the host that created the backup file.
Use the -force option to override this requirement.
Put the host into maintenance mode by running the command:#>
Set-VMHost -VMHost esxiprd08.unimedrj.root -State 'Maintenance'
#Restore the configuration from the backup bundle by running the command:
$backup_file = "C:\temp\bkphost\configBundle-esxiprd08.unimedrj.root.tgz"
Set-VMHostFirmware -VMHost esxiprd08.unimedrj.root -Restore -SourcePath $backup_file -HostUser root -HostPassword $m4n3t4r#

$vms = get-vm -Datastore compellent-vmfs5 | select name,MemoryGB,@{label="ProvisionedSpaceGB";expression={"{0:N0}" -f $_.ProvisionedSpaceGB}}, @{Label="UsedGB";Expression={"{0:N2}" -f ($_.UsedSpaceGB)}} 

$vms | Export-Csv c:\temp\vmsconsumo.csv
"{0:N0}" -f $vm.ProvisionedSpaceGB

$MyHost="esxiprd28.unimedrj.root"
$ESXiHost=Get-VMHost $MyHost

<#
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-07" -Path naa.6000d310008a1b000000000000000024 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-08" -Path naa.6000d310008a1b000000000000000025 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-09" -Path naa.6000d310008a1b000000000000000026 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-10" -Path naa.6000d310008a1b000000000000000027 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-11" -Path naa.6000d310008a1b000000000000000028 -FileSystemVersion 5
$ESXiHost | New-Datastore -Vmfs -Name "compellent-DS-AllTier-12" -Path naa.6000d310008a1b000000000000000029 -FileSystemVersion 5
#>


get-cluster -name Cluster-M610-Nehalem | Get-VMGuestNetworkInterface



$saida = Get-Datacenter -name *barra | Get-VM | select name,  powerstate, @{Label="ProvisionedGB";Expression={"{0:N2}" -f ($_.ProvisionedSpaceGB)}}, @{Label="UsedGB";Expression={"{0:N2}" -f ($_.UsedSpaceGB)}} 
$saida | Export-Csv C:\temp\vmsconsumo.csv -Encoding Unicode



Disconnect-VIServer -Confirm:$false
Connect-VIServer esxilab1
Set-VMHostAdvancedConfiguration -Name Config.HostAgent.plugins.solo.enableMob  -Value True
get-VMHostAdvancedConfiguration -Name Config.HostAgent.plugins.solo.enableMob
Disconnect-VIServer -Confirm:$false
Connect-VIServer 10.100.1.251

#/etc/vmware/config file. One of the way is to use “echo” command to append it to the config file, and the other way is to use the “vi” editor. To enable this virtualized HV 
#(Hardware Virtualization) we will add the string vhv.enable = “TRUE” 
# https://10.100.1.250/mob/?moid=ha-host&doPath=capability


Add-WindowsFeature "FS-NFS-Service"
New-NfsShare -Name "NFS_MOUNT" -Path "D:\NFS_MOUNT" -AllowRootAccess $true -Permission Readwrite -Authentication all
$VMHOST = "esxiprd11.unimedrj.root" # VMware vSphere host where to create the datastore
$NFSDatastore = "NFS_BKP2" # name that you want to give
$NFSServer = "10.100.1.251" # ip of fqdn of the NFS Server
$NFSSharename = "NFS_MOUNT" # Share created on the NFS Server

New-Datastore -Nfs -VMHost $VMHOST -Name $NFSDatastore -NfsHost $NFSServer -path $NFSSharename


(Get-VMhost esxiprd22.unimedrj.root | get-vm | ?{$_.PowerState -eq "poweredOn"}).count
(Get-VMhost esxiprd23.unimedrj.root | get-vm | ?{$_.PowerState -eq "poweredOn"}).count
(Get-VMhost esxiprd24.unimedrj.root | get-vm | ?{$_.PowerState -eq "poweredOn"}).count
(Get-VMhost esxiprd25.unimedrj.root | get-vm | ?{$_.PowerState -eq "poweredOn"}).count
(Get-VMhost esxiprd26.unimedrj.root | get-vm | ?{$_.PowerState -eq "poweredOn"}).count
(Get-VMhost esxiprd27.unimedrj.root | get-vm | ?{$_.PowerState -eq "poweredOn"}).count
(Get-VMhost esxiprd28.unimedrj.root | get-vm | ?{$_.PowerState -eq "poweredOn"}).count


$VMHost = Get-VMHost -Name esxiprd12.unimedrj.root

Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b00000000000000001b
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b00000000000000001d
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b00000000000000001e
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b00000000000000001f
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000020
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000021
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000022
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000023
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000024
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000025
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000026
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000027
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000028
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b000000000000000029
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b00000000000000000a
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b00000000000000000b
Detach-Disk -VMHost $VMHost -CanonicalName naa.6000d310008a1b00000000000000000c

detach-d

$vm = get-vm -Name osdbpp01

Get-VMGuest -VM $vm | select *



$saida = get-CDPinfo -hostname esxiprd27.unimedrj.root
$saida[0].ConnectedSwitchPort.HardwarePlatform
$saida[0].ConnectedSwitchPort.DevId
$saida[0].ConnectedSwitchPort.PortId

$saida = @()
Get-VMHost esxiprd17.unimedrj.root  |  
%{Get-View $_.ID} |  
%{$esxname = $_.Name; Get-View $_.ConfigManager.NetworkSystem} |  
%{ foreach($physnic in $_.NetworkInfo.Pnic){  
    $pnicInfo = $_.QueryNetworkHint($physnic.Device)  
    foreach($hint in $pnicInfo){  
      #Write-Host $esxname $physnic.Device  
      if( $hint.ConnectedSwitchPort )
      {  
            $tmp = new-object PSObject
            $tmp | add-member -type NoteProperty -Name "DevID" -Value $hint.ConnectedSwitchPort.DevID
            $tmp | add-member -type NoteProperty -Name "PortID" -Value $hint.ConnectedSwitchPort.PortID
            $tmp | add-member -type NoteProperty -Name "HardwarePlatform" -Value $hint.ConnectedSwitchPort.HardwarePlatform
            $tmp | add-member -type NoteProperty -Name "vnic" -Value $physnic.Device 
            $saida += $tmp
        
        
        #$hint.ConnectedSwitchPort  
      }else
      {  
        #Write-Host "No CDP information available."; Write-Host  
      }  
    }  
  }  
}

$saida

$NetworkName_str = "Rede 10.200.100.x"
$host_str = 
function Get-VMOnNetworkPortGroup {
    param(
        ## name of network to get; regex pattern
        [parameter(Mandatory=$true)][string]$NetworkName_str
    ) ## end param
 
    ## get the .NET View objects for the network port groups whose label match the given name
    $arrNetworkViews = Get-View -ViewType Network -Property Name -Filter @{"Name" = $NetworkName_str}
    if (($arrNetworkViews | Measure-Object).Count -eq 0) {Write-Warning "No networks found matching name '$NetworkName_str'"; exit}
 
    ## get the networks' VMs' names, along with the name of the corresponding VMHost and cluster
    $arrNetworkViews | %{$_.UpdateViewData("Vm.Name","Vm.Runtime.Host.Name","Vm.Runtime.Host.Parent.Name")}
    ## create a new object for each VM on this network
    $arrNetworkViews | %{
        $viewNetwk = $_
        $viewNetwk.LinkedView.Vm | %{
            New-Object -TypeName PSObject -Property @{
                VMName = $_.Name
                NetworkName = $viewNetwk.Name
                VMHost = $_.Runtime.LinkedView.Host.Name
                Cluster = $_.Runtime.LinkedView.Host.LinkedView.Parent.Name
            } | Select-Object VMName,NetworkName,VMHost,Cluster
        } ## end foreach-object
    } ## end foreach-object
} ## end fn



$VPs = Get-VirtualPortGroup | Group-Object name | select name 
foreach( $vp in $vps){

$saida = Get-VMOnNetworkPortGroup -NetworkName_str "Rede 10.100.x.x"
$order = $saida| Group-Object vmhost | select name, count
Get-VMHost -Name $order[0].Name | Get-VirtualSwitch | Get-VirtualPortGroup -Name $saida[0].NetworkName | select VirtualSwitchname


}


Get-VMOnNetworkPortGroup -NetworkName_str "Rede 10.100.x.x" | ?{$_.vmhost -eq "esxiprd25.unimedrj.root"} | Group-Object networkname

$hosts = Get-Cluster Cluster-m610-nehalem | Get-VMHost
foreach($hst in $hosts)
{
    $hst | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.100.x.x"

}

Get-VMHost -Name esxiprd08.unimedrj.root | New-VirtualSwitch -Name "vSwitch2"

Get-VMHost -Name esxiprd08.unimedrj.root | Get-vmhostNetworkAdapter | ?{}

Get-VMHost -Name esxiprd08.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.108.x" -VLanId 108
Get-VMHost -Name esxiprd11.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.108.x" -VLanId 108
Get-VMHost -Name esxiprd12.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.108.x" -VLanId 108
Get-VMHost -Name esxiprd16.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.108.x" -VLanId 108
Get-VMHost -Name esxiprd20.unimedrj.root | Get-VirtualSwitch -Name "vswitch0" | New-VirtualPortGroup -Name "Rede 10.200.108.x" -VLanId 108

function Get-VMHostPciDevice {
<#
.SYNOPSIS
  Returns the ESX(i) host's PCI Devices
.DESCRIPTION
  This function returns the ESX(i) host's PCI devices en their associated ESX devices
.NOTES
  Author:  Arnim van Lieshout
.PARAMETER VMHost
  The ESX(i) host entity for which the PCI devices should be returned
.EXAMPLE
  PS> Get-VMHostPciDevice -VMHost (Get-VMHost "esx01")
.EXAMPLE
  PS> Get-VMHost "esx01" | Get-VMHostPciDevice
#>
 
    Param (
    [parameter(valuefrompipeline = $true, mandatory = $true,
    HelpMessage = "Enter an ESX(i) host entity")]
    [VMware.VimAutomation.Types.VIObject[]]$VMHost)
 
    Begin {
# Create PCI class array
        $PciClass = @("Unclassified device","Mass storage controller","Network controller","Display controller","Multimedia controller","Memory controller","Bridge","Communications controller","Generic system peripheral","Input device controller","Docking station","Processor","Serial bus controller","Wireless controller","Intelligent controller","Satellite communications controller"," Encryption controller","Signal processing controller")
    }
 
    Process {
        if($VMHost) {
            $VMHostView = $VMHost | Get-View
        }
        else {
            $VMHostView = $_ | Get-View
        }
 
# Get the PCI Devices
        $VMHostView | % {
            $PciDevices = @()
            foreach ($dev in $_.Hardware.PciDevice) {
                $objDevice = "" | Select Pci, ClassName, VendorName, DeviceName, EsxDeviceName
                $objDevice.Pci = $dev.Id
                $objDevice.ClassName = $PciClass[[int]($dev.ClassId/256)]
                $objDevice.VendorName = $dev.VendorName
                if ($dev.DeviceName -notmatch "Unknown") {
                    $objDevice.DeviceName = $dev.DeviceName
                }
                $PciDevices += $objDevice
            }
 
# Find associated ESX storage devices
            foreach ($hba in $_.Config.StorageDevice.HostBusAdapter) {
                $PciDevices | ? {$_.Pci -match $hba.Pci} | % {$_.EsxDeviceName = "["+$hba.device+"]"}
            }
 
# Find associated ESX network devices
            foreach ($nic in $_.Config.Network.Pnic) {
                $PciDevices | ? {$_.Pci -match $nic.Pci} | % {$_.EsxDeviceName = "["+$nic.device+"]"}
            }
        }
    }
 
    End {
        $PciDevices| Sort-Object -Property Pci
    }
}


function Get-VmwarePathStatus(){
clear
$views = Get-View -ViewType "HostSystem" -Property Name,Config.StorageDevice 
$result = @()
 
foreach ($view in $views | Sort-Object -Property Name) {
    Write-Host "Checking" $view.Name
 
    $view.Config.StorageDevice.ScsiTopology.Adapter |?{ $_.Adapter -like "*FibreChannelHba*" } | %{
        $hba = $_.Adapter.Split("-")[2]
 
        $active = 0
        $standby = 0
        $dead = 0
 
        $_.Target | %{ 
            $_.Lun | %{
                $id = $_.ScsiLun
 
                $multipathInfo = $view.Config.StorageDevice.MultipathInfo.Lun | ?{ $_.Lun -eq $id }
 
                $a = [ARRAY]($multipathInfo.Path | ?{ $_.PathState -like "active" })
                $s = [ARRAY]($multipathInfo.Path | ?{ $_.PathState -like "standby" })
                $d = [ARRAY]($multipathInfo.Path | ?{ $_.PathState -like "dead" })
 
                $active += $a.Count
                $standby += $s.Count
                $dead += $d.Count
            }
        }
 
        $result += "{0},{1},{2},{3},{4}" -f $view.Name, $hba, $active, $dead, $standby
    }
}
 
ConvertFrom-Csv -Header "VMHost", "HBA", "Active", "Dead", "Standby" -InputObject $result | ft -AutoSize
}

Get-VmwarePathStatus


#dell compellent
Get-Cluster cluster-m620 | Get-VMHost | Get-ScsiLun | where {$_.Vendor -eq "COMPELNT" –and $_.Multipathpolicy -eq "Fixed" -and $_.capacity -gt 30} #  | Set-ScsiLun -Multipathpolicy RoundRobin

#EMC VNX
Get-Cluster Cluster-M610-Nehalem | Get-VMHost | Get-ScsiLun | where {$_.Vendor -eq "DGC" –and $_.Multipathpolicy -eq "Fixed"} | Set-ScsiLun -Multipathpolicy RoundRobin

Get-VMHost -Name esxiprd12.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC" } | Set-ScsiLun -Multipathpolicy RoundRobin
Get-VMHost -Name esxiprd11.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC" } | Set-ScsiLun -Multipathpolicy RoundRobin
Get-VMHost -Name esxiprd08.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC" –and $_.Multipathpolicy -eq "Fixed"} | Set-ScsiLun -Multipathpolicy RoundRobin
Get-VMHost -Name esxiprd11.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC" –and $_.Multipathpolicy -eq "Fixed"} | Set-ScsiLun -Multipathpolicy RoundRobin
Get-VMHost -Name esxiprd12.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC" –and $_.Multipathpolicy -eq "Fixed"} | Set-ScsiLun -Multipathpolicy RoundRobin
Get-VMHost -Name esxiprd20.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC" –and $_.Multipathpolicy -eq "Fixed"} | Set-ScsiLun -Multipathpolicy RoundRobin
Get-VMHost -Name esxiprd28.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC"  –and $_.Multipathpolicy -eq "MostRecentlyUsed" } | Set-ScsiLun -Multipathpolicy RoundRobin


(Get-VMHost -Name esxiprd08.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC"}).count
(Get-VMHost -Name esxiprd11.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC"}).count
(Get-VMHost -Name esxiprd12.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC"}).count
(Get-VMHost -Name esxiprd20.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "DGC"}).count

Get-Cluster  Cluster-M610-Nehalem | Get-VMHost | Get-ScsiLun | where {$_.Vendor -eq "DGC"}-and $_.MultipathPolicy -eq "fixed" } | Set-ScsiLun -Multipathpolicy RoundRobin

Get-VMHost -Name esxiprd28.unimedrj.root| Get-ScsiLun | where {$_.Vendor -eq "COMPELNT" -and $_.CapacityGB -gt "10"} | ft -AutoSize

Get-Cluster  Cluster-M610-Nehalem | Get-VMHost | Get-ScsiLun | where {$_.Vendor -eq "DGC"}| select vendor, LunType, CapacityGB, MultipathPolicy, CommandsToSwitchPath

Get-Cluster Cluster-M610-Nehalem | Get-VMHost | Get-VMHostStorage -RescanAllHba

Get-Cluster  POC-Purestorage | Get-VMHost | Get-ScsiLun | where {$_.Vendor -eq "PURE" }| select vendor, LunType, CapacityGB, MultipathPolicy, CommandsToSwitchPath

Get-VMHost -Name esxiprd28.unimedrj.root | Get-ScsiLun | select vendor, LunType, CapacityGB, MultipathPolicy 

$esxcli = get-esxcli -VMHost esxiprd28.unimedrj.root 
$esxcli.storage.core.adapter.list() | ?{$_.UID -like "fc.*"}
$esxcli.storage.san.fc.reset("vmhba4")  

Get-VmwarePathStatus

get-datacenter *barra* | get-vm | ?{$_.powerstate -eq "poweredOn"} | ft name -AutoSize


$hosts = Get-VMHost
foreach($hst in $hosts)
{
    Get-VMHostHba -VMHost $hst -Type FibreChannel  | select vmhost, device,status, speed
}

Get-VMHost -Name esxiprd28.unimedrj.root |Get-VMHostHba |Select-Object -Property Name,VMHost,Speed

function Get-FCPathDead()
{
clear
$views = Get-View -ViewType "HostSystem" -Property Name,Config.StorageDevice
$result = @()
 
foreach ($view in $views | Sort-Object -Property Name) {
    Write-Host "Checking" $view.Name
 
    $view.Config.StorageDevice.ScsiTopology.Adapter |?{ $_.Adapter -like "*FibreChannelHba*" } | %{
        $hba = $_.Adapter.Split("-")[2]
 
        $active = 0
        $standby = 0
        $dead = 0
 
        $_.Target | %{ 
            $_.Lun | %{
                $id = $_.ScsiLun
 
                $multipathInfo = $view.Config.StorageDevice.MultipathInfo.Lun | ?{ $_.Lun -eq $id }
 
                $path = [ARRAY]($multipathInfo.Path | ?{ $_.PathState -like "dead" })
                if($path){               
                $state = $path.state
                $canonicalname = $path.name.Split("-")[($path.name.Split("-")).count-1]
                $size = (Get-ScsiLun -CanonicalName $canonicalname -VmHost $view.name).capacityGB
                $result += "{0},{1},{2},{3},{4}" -f $view.Name, $hba, $state, $canonicalname, $size
                }

            }
        }
 

    }
}
 
ConvertFrom-Csv -Header "VMHost", "HBA", "State", "Canonicalname", "Lun Size" -InputObject $result | ft -AutoSize
}


Get-FCPathDead 
 

Get-Cluster  Cluster-M610-Nehalem | Get-VM | %{get-RDMFromVM -vmname $_.name}

get-RDMFromVM -vmname neodbinv01


Get-Cluster POC-PureStorage | Get-VMHost | New-Datastore -Nfs -Name NFS1 -Path "/dbexportdell" -NfsHost unifs01.unimedrj.root


New-HardDisk -VM dwdbpoc02 -StorageFormat thin -CapacityGB 1350 |  New-ScsiController -Type ParaVirtual
New-HardDisk -VM dwdbpoc02 -StorageFormat thin -CapacityGB 1350 
New-HardDisk -VM dwdbpoc02 -StorageFormat thin -CapacityGB 1350 
New-HardDisk -VM dwdbpoc02 -StorageFormat thin -CapacityGB 1350 
New-HardDisk -VM dwdbpoc02 -StorageFormat thin -CapacityGB 1350 
New-HardDisk -VM dwdbpoc02 -StorageFormat thin -CapacityGB 1350 

Get-HardDisk -vm "unifs01" | where {$_.Name -eq "hard disk 1"} | Set-HardDisk -CapacityGB 35 -Confirm:$false

