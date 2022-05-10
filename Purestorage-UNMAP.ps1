$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1

$UNMAPBlockCount = "<enter integer>"

write-host "Initiating VMFS UNMAP for all Pure Storage volumes in the vCenter"
write-host "Searching for VMFS volumes to reclaim (UNMAP)"
$datastores = get-datastore
write-host "Found " $datastores.count " VMFS volume(s)."
$purevols = $datastores |get-scsilun |where-object {$_.CanonicalName -like "naa.624a9370*"} |sort-object -unique
write-host "Of these volumes, " $purevols.count " of them are Pure Storage devices."
write-host
write-host "Iterating through VMFS volumes and running a reclamation on Pure Storage volumes only"
write-host "UNMAP will use a block count iteration of " $UNMAPBlockCount
write-host "Please be patient, this process can take a long time depending on how many volumes and their capacity"
$volcount=0
foreach ($datastore in $datastores)
{
   $esx = $datastore | get-vmhost |Select-object -last 1
   $lun = get-scsilun -datastore $datastore | select-object -last 1
   $esxcli=get-esxcli -VMHost $esx
   write-host "--------------------------------------------------------------------------"
   write-host "Analyzing the following volume:"
   write-host $datastore.Name $lun.CanonicalName
   if ($lun.canonicalname -like "naa.624a9370*")
   {
       write-host $datastore.name "is a Pure Storage Volume and will be reclaimed."
       write-host "Initiating reclaim...Operation time will vary depending on block count, size of volume and other factors."
       $esxcli.storage.vmfs.unmap($UNMAPBlockCount, $datastore.Name, $null) |out-null
       write-host "Reclaim complete."
       $volcount=$volcount+1
   }
   else
   {
       write-host $datastore.name " is not a Pure Volume and will not be reclaimed. Skipping..."
   }
}
write-host "--------------------------------------------------------------------------"
write-host "Reclamation finished. A total of " $volcount " Pure Storage volume(s) were reclaimed"