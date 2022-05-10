

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


$x = 2  
$y = 2 
#cria datastore clusters, criar os datastores que estão no datastore cluster, cria os hosts com as hbas e conecta tudo
$clusters = Get-DatastoreCluster 
foreach ($cluster in $clusters)
{
    $shapedatastorecluster = Create-visioShape -master $Masterdatastorecluster -points $x,$y -name $cluster.Name
    
    $txt = $cluster.Name + "`nCapacidade: "+ $cluster.CapacityGB + " GB`nFree: "+  ($cluster.FreeSpaceGB.ToString() -split ",","")[0]+ " GB`nSRSD Auto Level: "+ $cluster.SdrsAutomationLevel
    set-VisioShapeText -Text $txt -Shapes $shapedatastorecluster
    $datastores = $cluster | Get-Datastore

    
    foreach($dts in $datastores)
    {
        
        $y=6
        $nameshape = $cluster.Name + $dts.name
        $shapedatastore = Create-visioShape -master $masterDisk -points $x,$y -name $nameshape
        Create-VisioConnection -FromName $nameshape -toName $cluster.Name
        $txt = $dts.name + "`nCapacidade: "+ $dts.CapacityGB + " GB`nFree: "+  ($dts.FreeSpaceGB.ToString() -split ",","")[0] +" GB"
        Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $nameshape)
        $x+=3

        [array]$luns = $dts | get-scsilun -LunType disk | sort -Unique
        foreach($lun in $luns)
        {
            $y=9
            $nameshape = $cluster.Name + $dts.name + $lun.canonicalname
            $shapespindle = Create-visioShape -master $masterSpindle -points $x,$y -name $nameshape
            Create-VisioConnection -FromName $nameshape -toName ($cluster.Name + $dts.name)
            $txt = "Lun ID:"+$Lun.RuntimeName.Substring($Lun.RuntimeName.LastIndexof(“L”)+1) + "`nCapacidade: "+ $lun.CapacityGB +  "GB`nVendor: "+$lun.vendor
            Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $nameshape)
            $x+=3
            
        }

    }


   [array]$hosts = $cluster | Get-VMHost
    foreach($hostvm in $hosts)
    {    
        $y=0
        $shapehost = Create-visioShape -master $masterhost -points $x,$y -name $hostvm.Name
        #Create-VisioConnection -FromName $hostvm.Name -toName $cluster.Name
        $txt = $hostvm.Name  +  "`n"+$hostvm.Manufacturer+ " " +$hostvm.Model+ "`nESXIVersion: " + $hostvm.Version
        Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapehost.Name)
        $x+=3      
        
        [array]$hbas = Get-VMHostHba -VMHost $hostvm -Type FibreChannel  
        foreach($hba in $hbas)
        {
               $y=2
               $shapeHBA = Create-visioShape -master $MasterPCICard -points $x,$y -name ($hostvm.Name + $hba.device)
               Create-VisioConnection -FromName ($hostvm.Name + $hba.device) -toName $hostvm.Name
               Set-VisioShapeText -Text ($hba.Device + "`n"+$hba.Speed + "gbps")-Shapes (Get-VisioShape -NameOrID $shapehba.Name)
               if($hba.Status -eq "online"){ Create-VisioConnection -FromName ($hostvm.Name + $hba.device) -toName $cluster.Name}
               $x+=3 
            

        }
        
    }

}


$datastores = Get-Datastore 
foreach($dts in $datastores)
{
    
    $y=6
    $nameshape = $cluster.Name + $dts.name
    $shapedatastore = Create-visioShape -master $masterDisk -points $x,$y -name $nameshape
    #Create-VisioConnection -FromName $nameshape -toName $cluster.Name
    $txt = $dts.name + "`nCapacidade: "+ $dts.CapacityGB + " GB`nFree: "+  ($dts.FreeSpaceGB.ToString() -split ",","")[0] +" GB"
    Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $nameshape)
    $x+=3
    <#
    [array]$luns = $dts | get-scsilun | sort -Unique
    foreach($lun in $luns)
    {
        $y=9
        $nameshape = $cluster.Name + $dts.name + $lun.canonicalname
        $shapespindle = Create-visioShape -master $masterSpindle -points $x,$y -name $nameshape
        Create-VisioConnection -FromName $nameshape -toName ($cluster.Name + $dts.name)
        $txt = "Lun ID:"+$Lun.RuntimeName.Substring($Lun.RuntimeName.LastIndexof(“L”)+1) + "`nCapacidade: "+ $lun.CapacityGB +  "GB`nVendor: "+$lun.vendor
        Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $nameshape)
        $x+=3
    }#>

}

#cria cluster e conecta nos hosts
$clusters  = Get-Cluster
foreach ($cluster in $clusters)
{
    $y=3
    $shapecluster = Create-visioShape -master $Mastercluster -points $x,$y -name $cluster.Name
    $txt = $cluster.Name + "`nHA: "+ $cluster.HAEnabled + "`nDRS: "+ $cluster.DrsEnabled + "`nVSAN: "+ $cluster.VsanEnabled +"`nEVC Mode: "+ $cluster.EVCMode 
    Set-VisioShapeText -Text $txt -Shapes $shapecluster
    $hosts = Get-Cluster -Name $cluster.Name | Get-VMHost
    foreach($hostvm in $hosts)
    { 
        Create-VisioConnection -FromName $hostvm.Name -toName $cluster.Name
    }
    $x+=3
}


$hba.Speed