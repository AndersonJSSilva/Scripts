function Create-visioShape($master, $points, $name){
$shape = New-VisioShape $master -Points $points -Names $name
Set-VisioShapeText -Text $name -Shapes $shape
return $shape
}
function Create-VisioConnection($FromName,$toName){
New-VisioConnection -From (Get-VisioShape -NameOrID $FromName) -To (Get-VisioShape -NameOrID $toName)
}
function get-CDPinfo($hostname){
$saida = @()
Get-VMHost $hostname  |  
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

return $saida
}
function Get-VMOnNetworkPortGroup {
    param(
        ## name of network to get; regex pattern
        [parameter(Mandatory=$true)][string]$NetworkName_str
    ) ## end param
 
    ## get the .NET View objects for the network port groups whose label match the given name
    $arrNetworkViews = Get-View -ViewType Network -Property Name -Filter @{"Name" = $NetworkName_str}
    if (($arrNetworkViews | Measure-Object).Count -eq 0) {Write-Warning "No networks found matching name '$NetworkName_str'"; return}
 
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
}