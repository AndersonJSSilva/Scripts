$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1

$clustername = "POC-PureStorage"
$hosts = get-cluster $clustername | get-vmhost
foreach ($esx in $hosts) 
{
      $esxcli=get-esxcli -VMHost $esx 
      $devices = Get-Cluster $clustername |Get-VMhost $esx |Get-ScsiLun -CanonicalName "naa.624a9370*"
      $devices
      <#foreach ($device in $devices)
      {
          Get-VMhost $esx |Get-ScsiLun $device |Set-ScsiLun -MultipathPolicy RoundRobin 
          $esxcli.storage.nmp.psp.roundrobin.deviceconfig.set($null,$null,$device.CanonicalName,1,"iops",$null)
      }#>
}


$hosts = get-cluster $clustername | get-vmhost
foreach ($esx in $hosts)
{
    $esxcli=get-esxcli -VMHost $esx
    $esxcli.storage.nmp.satp.rule.add($null, $null, "PURE FlashArray RR IO Operation Limit Rule", $null, $null, $null, "FlashArray",$null, "VMW_PSP_RR", "iops=1", "VMW_SATP_ALUA", $null, $null, "PURE")
} 