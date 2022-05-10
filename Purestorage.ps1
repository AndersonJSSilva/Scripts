$hosts = get-cluster POC* | get-vmhost
foreach ($esx in $hosts) 
{
      $esxcli=get-esxcli -VMHost $esx 
      $devices = Get-Cluster POC* |Get-VMhost $esx |Get-ScsiLun -CanonicalName "naa.624a9370*"
      foreach ($device in $devices)
           {
               Get-VMhost $esx |Get-ScsiLun $device |Set-ScsiLun -MultipathPolicy RoundRobin 
               $esxcli.storage.nmp.psp.roundrobin.deviceconfig.set($null,$null,$device.CanonicalName,1,”iops”,$null)
           }
}