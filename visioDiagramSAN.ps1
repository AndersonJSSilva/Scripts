$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1
Import-Module Visio

New-VisioApplication
New-VisioDocument
$vmwareStencil = Open-VisioDocument 'C:\Users\m41718\Documents\VMware EUC Visio Stencils 2015.vss'
$MasterHost = Get-VisioMaster "ESXi Host" -Document $vmwareStencil
$Mastervsiwtch = Get-VisioMaster "VSwtch 3D" -Document $vmwareStencil
$MasterPCICard = Get-VisioMaster "PCI Card" -Document $vmwareStencil
$MasterCluster = Get-VisioMaster "Clusters 2" -Document $vmwareStencil
$MasterPortGroup = Get-VisioMaster "Switch 1" -Document $vmwareStencil
$MasterCisco = Get-VisioMaster "Cisco Switch 1" -Document $vmwareStencil
$MasterVM = Get-VisioMaster "Virtual Machine (3D)" -Document $vmwareStencil
$masterSpindle = Get-VisioMaster "Spindle 1" -Document $vmwareStencil
$masterDisk = Get-VisioMaster "Disks 1" -Document $vmwareStencil
$masterDataStoreCluster = Get-VisioMaster "Datastorecluster" -Document $vmwareStencil
$masterDiskArray = Get-VisioMaster "Disk Array" -Document $vmwareStencil


[array]$SFCs = @(("SW_01","Brocade`nSW_01"),("SW_02","Brocade`nSW_02"),("SW_03","Brocade`nSW_03"),("SW_04","Brocade`nSW_04"),("SW_05","Brocade`nSW_05"),("SW_06","Brocade`nSW_06"))
$x=0
$y=0
foreach($fc in $sfcs)
{
    $x++
    $ShapeSFC = Create-visioShape -master $MasterPortGroup -points $x,2 -name $fc[$y]
    $ShapeSFC.Resize(1,-53,70)
    $txt = $fc[$y+1]
    Set-VisioShapeText -Text $txt -Shapes $ShapeSFC 
}
$x=0
$y=0

$shapeCompelnt = Create-visioShape -master $masterDiskArray -points 2,4 -name "COMPELNT"
$ShapeCompelnt.Resize(1,-40,70)
Set-VisioShapeText -Text "Dell`nCompellent SC4020" -Shapes $shapeCompelnt

$shapeDGC = Create-visioShape -master $masterDiskArray -points 4,4 -name "DGC"
$ShapeDGC.Resize(1,-40,70)
Set-VisioShapeText -Text "EMC`nVNX 7600" -Shapes $shapeDGC

$names = Get-Datacenter -Name "Unimed Rio - Barra" | Get-VMHost | select name
[array]$luns = @()
foreach($name in $names)
{        
        [array]$luns += get-vmhost -Name $name.Name | get-scsilun -LunType disk | sort -Unique

}
$luns = $luns | sort -Unique | ?{$_.vendor -ne "DELL"}
foreach($lun in $luns)
{
      $y=1
      $nameshape = $lun.canonicalname
      $shapespindle = Create-visioShape -master $masterSpindle -points $x,$y -name $nameshape
      $shapespindle.Resize(1,-25,70)
      Create-VisioConnection -FromName $nameshape -toName $lun.vendor
      $txt = "ID:"+$Lun.RuntimeName.Substring($Lun.RuntimeName.LastIndexof(“L”)+1) +"`n"+ $lun.CapacityGB +  "GB"
      Set-VisioShapeText -Text $txt -Shapes $shapespindle
      $x+=1

}

foreach($lun in $luns)
{
     "Lun ID:"+$Lun.RuntimeName.Substring($Lun.RuntimeName.LastIndexof(“L”)+1) +";Size: "+ $lun.CapacityGB +  "GB;" + $lun.vendor
}

$x=0
$y=0

   [array]$hosts = Get-Datacenter -Name "Unimed Rio - Barra" | Get-VMHost
    foreach($hostvm in $hosts)
    {    
        $y=0
        $shapehost = Create-visioShape -master $masterhost -points $x,$y -name $hostvm.Name
        $shapehost.Resize(1,-32,70)
        #Create-VisioConnection -FromName $hostvm.Name -toName $cluster.Name
        $txt = $hostvm.Name  +  "`n"+$hostvm.Manufacturer+ " " +$hostvm.Model+ "`nESXIVersion: " + $hostvm.Version
        Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapehost.Name)
        $x+=1      
        
        [array]$hbas = Get-VMHostHba -VMHost $hostvm -Type FibreChannel  
        foreach($hba in $hbas)
        {
               $y=1
               $shapeHBA = Create-visioShape -master $MasterPCICard -points $x,$y -name ($hostvm.Name + $hba.device)
               $shapeHBA.Resize(1,-20,70)
               Create-VisioConnection -FromName ($hostvm.Name + $hba.device) -toName $hostvm.Name
               Set-VisioShapeText -Text ($hba.Device + "`n"+$hba.Speed + "gbps`n" + $hba.Status )-Shapes (Get-VisioShape -NameOrID $shapehba.Name)
               #if($hba.Status -eq "online"){ Create-VisioConnection -FromName ($hostvm.Name + $hba.device) -toName $cluster.Name}
               $x+=1 
            

        }
        
    }
$x=0
$y=0
