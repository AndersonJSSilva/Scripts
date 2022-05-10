$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1
Import-Module Visio



New-VisioApplication
New-VisioDocument
$vmwareStencil = Open-VisioDocument 'C:\Users\m41718\Documents\VMware EUC Visio Stencils 2015.vss'
$MasterHost = Get-VisioMaster "Vmware Host" -Document $vmwareStencil
$Mastervsiwtch = Get-VisioMaster "VSwtch 3D" -Document $vmwareStencil
$MasterPCICard = Get-VisioMaster "PCI Card" -Document $vmwareStencil
$MasterCluster = Get-VisioMaster "Clusters 2" -Document $vmwareStencil
$MasterPortGroup = Get-VisioMaster "Switch 1" -Document $vmwareStencil
$MasterCisco = Get-VisioMaster "Cisco Switch 1" -Document $vmwareStencil
$MasterVM = Get-VisioMaster "Virtual Machine (3D)" -Document $vmwareStencil


$ShapeCiscoCore = Create-visioShape -master $MasterCisco -points 0,2 -name "CORE_BARRA"
$txt = "cisco WS-C4510R-E `nCORE_BARRA"
Set-VisioShapeText -Text $txt -Shapes $ShapeCiscoCore

$ShapeCiscoDMZ = Create-visioShape -master $MasterCisco -points 0,5 -name "SW_DC_DMZ"
$txt = "cisco WS-C2960G-48TC-L `nSW_DC_DMZ"
Set-VisioShapeText -Text $txt -Shapes $ShapeCiscoDMZ

$ShapeCiscoBEN = Create-visioShape -master $MasterCisco -points 0,7 -name "CORE_BENFICA_1"
$txt = "cisco WS-C4510R-E `nCORE_BENFICA_1"
Set-VisioShapeText -Text $txt -Shapes $ShapeCiscoBEN


$x = 2  


$clusters = Get-Cluster -Name Cluster-R820

foreach ($cluster in $clusters)
{
    $y = 2 
    $shapecluster = Create-visioShape -master $Mastercluster -points $x,$y -name $cluster.Name
    $txt = $cluster.Name + "`nHA: "+ $cluster.HAEnabled + "`nDRS: "+ $cluster.DrsEnabled + "`nVSAN: "+ $cluster.VsanEnabled +"`nEVC Mode: "+ $cluster.EVCMode 
    Set-VisioShapeText -Text $txt -Shapes $shapecluster
    $hosts = Get-Cluster -Name $cluster.Name | Get-VMHost

    
    foreach($hostvm in $hosts)
    {
    
        $y=6
        $cdps = get-CDPinfo -hostname $hostvm.Name
        $shapehost = Create-visioShape -master $masterhost -points $x,$y -name $hostvm.Name
        Create-VisioConnection -FromName $hostvm.Name -toName $cluster.Name
        $txt = $hostvm.Name  +  "`n"+$hostvm.Manufacturer+ " " +$hostvm.Model+ "`nESXIVersion: " + $hostvm.Version + "`nRAM(GB): " + [math]::Round([decimal]$hostvm.MemoryTotalGB,2) +"`nCPU: "  + $hostvm.ProcessorType + "`nNum CPU: " +$hostvm.NumCpu 
        Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapehost.Name)
        $x+=3
        $vswitchs = Get-VMHost -Name $hostvm.Name | Get-VirtualSwitch
        foreach($vswitch in $vswitchs)
        {
            $y=8
            $nameshape = $hostvm.name + $vswitch.Name
            $shapeVSwitch = Create-visioShape -master $Mastervsiwtch -points $x,$y -name $nameshape
            $txt = $vswitch.name
            Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapeVSwitch.Name)
            Create-VisioConnection -FromName $hostvm.Name -toName $nameshape
            $x+=3
            
            
            if($vswitch.Nic)
            {
                foreach ($nic in ($vswitch.Nic))
                {
                    $y=10
                    $pcicard = Get-VMHostNetworkAdapter -VMHost $hostvm.Name -Name $nic
                    $nameshape = $hostvm.name + $vswitch.Name + $pcicard.Name
                    $shapeNIC = Create-visioShape -master $MasterPCICard -points $x,$y -name $nameshape
                    $txt = $pcicard.name +"`n"+ $pcicard.BitRatePerSec  +  "`n"+ $pcicard.IP
                    Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapeNIC.Name)
                    Create-VisioConnection -FromName $shapeVSwitch.Name -toName $nameshape
                    foreach($cdp in $cdps)
                    {                       
                        if ($cdp.vnic -eq $nic){
                        Create-VisioConnection -FromName $shapeNIC.Name -toName $cdp.DevID
                        $txt = Get-VisioShapeText -Shapes $shapeNIC
                        $txt = $txt + $cdp.PortID
                        Set-VisioShapeText -Text $txt -Shapes $shapeNIC
                        }                    
                    }
                    $x+=3
                                        
                }
            }
            $vpgourps = Get-VMHost -Name $hostvm.Name | Get-VirtualSwitch -Name $vswitch.Name | Get-VirtualPortGroup
            if($vpgourps)
            {
                   foreach($portgroup in $vpgourps)
                   {
                        $y=10
                        $nameshape = $hostvm.name + $vswitch.Name + $portgroup.name
                        $shapePortGroup = Create-visioShape -master $MasterPortGroup -points $x,$y -name $nameshape
                        
                        $vmks = get-VMHostNetworkAdapter -VMHost $hostvm.Name | ?{$_.PortGroupName -eq $portgroup.Name.ToString()}
                        if($vmks){
                        foreach($vmk in $vmks)
                        {    
                            $txt = $portgroup.Name +"`nIP: "+ $vmk.IP +"`nVmotion: "+$vmk.VMotionEnabled+"`nFT: "+$vmk.FaultToleranceLoggingEnabled+"`nMGMT: "+$vmk.ManagementTrafficEnabled+"`nVSAN:"+$vmk.VsanTrafficEnabled+"`n"
                                                  }
                        }else{$txt = $portgroup.Name}
                        Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapePortGroup.Name)
                        Create-VisioConnection -FromName $shapeVSwitch.Name -toName $nameshape

                        $vms = Get-VMOnNetworkPortGroup -NetworkName_str $portgroup.Name | ?{$_.vmhost -eq $hostvm.Name.ToString() } | Group-Object networkname
                        if($vms)
                        {
                            $y+=3
                            $nameshape = $hostvm.name + $vswitch.Name + $portgroup.name + "vms"
                            $shapevms = Create-visioShape -master $MasterVM -points $x,$y -name $nameshape
                            $txt = "VMs: "+$vms.Count
                            Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapevms.name)
                            $pgname = $hostvm.name + $vswitch.Name + $portgroup.name
                            Create-VisioConnection -FromName $shapevms.name -toName $pgname
                            $y-=3
                        }

                        $x+=3
                        $y=10
                        
                   }

                   

            }          


                        
        }
        
    } 
    $x+=3

}


