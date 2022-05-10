$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1
Import-Module Visio


New-VisioApplication
New-VisioDocument
$vmwareStencil = Open-VisioDocument 'C:\Users\m41718\Documents\VMware EUC Visio Stencils 2015.vss'
$MasterHost = Get-VisioMaster "Vmware Host" -Document $vmwareStencil
$MasterVM = Get-VisioMaster "Virtual Machine (3D)" -Document $vmwareStencil
$MasterCluster = Get-VisioMaster "Clusters 2" -Document $vmwareStencil

$x = 1  
$y = 1 

$clusters = Get-Cluster 

foreach ($cluster in $clusters)
{
    $shapecluster = Create-visioShape -master $Mastercluster -points $x,$y -name $cluster.Name
    $txt = $cluster.Name + "`nHA: "+ $cluster.HAEnabled + "`nDRS: "+ $cluster.DrsEnabled + "`nVSAN: "+ $cluster.VsanEnabled +"`nEVC Mode: "+ $cluster.EVCMode 
    Set-VisioShapeText -Text $txt -Shapes $shapecluster
    $hosts = Get-Cluster -Name $cluster.Name | Get-VMHost

    $y+=2
    foreach($hostvm in $hosts)
    {
        $shapehost = Create-visioShape -master $masterhost -points $x,$y -name $hostvm.Name
        Create-VisioConnection -FromName $hostvm.Name -toName $cluster.Name
        $txt = $hostvm.Name  +  "`nServer Model: "+$hostvm.Manufacturer+ " " +$hostvm.Model+ "`nESXIVersion: " + $hostvm.Version + "`nTotalMemory(GB): " + [math]::Round([decimal]$hostvm.MemoryTotalGB,2) +"`nCPU Model: "  + $hostvm.ProcessorType + "`nTotal MHz: "  +$hostvm.CpuTotalMhz+ "`nNum CPU: " +$hostvm.NumCpu 
        Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapehost.Name)
        $x++
        $vms = Get-VMHost -Name $hostvm.Name | Get-VM | ?{$_.powerstate -eq "PoweredOn"}| select guestostype | Group-Object guestostype |?{$_.name -ne ''} | select name,count 
        foreach($vm in $vms)
        {
            $nameshape = $vm.Name + $hostvm.name
            $shapevm = Create-visioShape -master $MasterVM -points $x,$y -name $nameshape
            $txt = "VMOS: " + $vm.Name  + "`nNumVMs: " + $vm.count
            Set-VisioShapeText -Text $txt -Shapes (Get-VisioShape -NameOrID $shapevm.Name)
            Create-VisioConnection -FromName $hostvm.Name -toName $nameshape
            $x++
            
        }

    } 

}