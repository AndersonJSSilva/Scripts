function Get-MaxIOPsVMsbyDatastore($datastorename, $lasttime){
$metrics = "disk.numberwrite.summation","disk.numberread.summation"
$start = (Get-Date).AddMinutes(-$lasttime)
$report = @()
$datastores = Get-Datastore -Name $datastorename
foreach($datastore in $datastores){ 

$vms = Get-VM -Datastore $datastore | where {$_.PowerState -eq "PoweredOn"}
$stats = Get-Stat -Realtime -Stat $metrics -Entity $vms -Start $start
$interval = $stats[0].IntervalSecs
 
$lunTab = @{}
foreach($ds in (Get-Datastore -VM $vms | where {$_.Type -eq "VMFS"})){
  $ds.ExtensionData.Info.Vmfs.Extent | %{
    $lunTab[$_.DiskName] = $ds.Name
  }
}
 
$report = $stats | Group-Object -Property {$_.Entity.Name},Instance | %{
  New-Object PSObject -Property @{
    VM = $_.Values[0]
    Disk = $_.Values[1]
    IOPSMax = ($_.Group | `
      Group-Object -Property Timestamp | `
      %{$_.Group[0].Value + $_.Group[1].Value} | `
      Measure-Object -Maximum).Maximum / $interval
    Datastore = $lunTab[$_.Values[1]]
  }
}
 
$report 
#$report[0].Datastore
#$report | Measure-Object -Sum IOPSMax | select sum

}
}
function Get-MaxIOPsbyVMs($vmname, $lasttime){
$metrics = "disk.numberwrite.summation","disk.numberread.summation"
$start = (Get-Date).AddMinutes(-$lasttime)
$report = @()
$vms = get-vm -Name $vmname
foreach($vm in $vms){ 

$vms = $vm
$stats = Get-Stat -Realtime -Stat $metrics -Entity $vms -Start $start
$interval = $stats[0].IntervalSecs
 
$lunTab = @{}
foreach($ds in (Get-Datastore -VM $vms | where {$_.Type -eq "VMFS"})){
  $ds.ExtensionData.Info.Vmfs.Extent | %{
    $lunTab[$_.DiskName] = $ds.Name
  }
}
 
$report = $stats | Group-Object -Property {$_.Entity.Name},Instance | %{
  New-Object PSObject -Property @{
    VM = $_.Values[0]
    Disk = $_.Values[1]
    IOPSMax = ($_.Group | `
      Group-Object -Property Timestamp | `
      %{$_.Group[0].Value + $_.Group[1].Value} | `
      Measure-Object -Maximum).Maximum / $interval
    Datastore = $lunTab[$_.Values[1]]
  }
}
 
$report 
#$report[0].Datastore
#$report | Measure-Object -Sum IOPSMax | select sum

}
}

$vms = Get-VMHost -Name esxiprd26.unimedrj.root | get-vm | ?{$_.powerstate -eq "poweredon"}
$vms | %{get-maxiopsbyVMs -vmname $_.name -lasttime 120}

Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-01 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-02 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-03 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-04 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-05 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-06 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-07 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-08 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-09 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-10 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-11 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum
Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-12 -lasttime 120 | Measure-Object -Sum IOPSMax | select sum

$result = Get-MaxIOPsVMsbyDatastore -datastorename compellent-DS-AllTier-* -lasttime 1 | Sort-Object iopsmax -Descending


Get-MaxIOPsVMsbyDatastore -datastorename *-03 -lasttime 1

(Get-Datastore -Name compellent-DS-AllTier-01 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-02 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-03 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-04 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-05 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-06 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-07 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-08 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-09 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-10 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-11 | Get-VM).count
(Get-Datastore -Name compellent-DS-AllTier-12 | Get-VM).count
 
Get-MaxIOPsbyVMs -vmname spodbprd01 -lasttime 120
Get-MaxIOPsbyVMs -vmname spoappprd01 -lasttime 120

Get-MaxIOPsbyVMs -vmname omegadbtst01 -lasttime 120
Get-VMHost -Name esxiprd28.unimedrj.root| Get-VM |?{$_.powerstate -eq "poweredon"}| %{Get-MaxIOPsbyVMs -vmname $_.name -lasttime 10} | ft -autosize


