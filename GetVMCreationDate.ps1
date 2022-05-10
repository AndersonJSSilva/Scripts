$vCenterIP = "vmvcenter.unimedrj.root"
try{
    #Import the PowerCLI module
    Add-PSSnapin VMware.VimAutomation.Core
 
    #Update the title bar
    $host.ui.rawui.WindowTitle="PowerShell [PowerCLI Module Loaded]"
    #Connect to the server
    Connect-VIServer $vCenterIP
}
catch {
    #Something failed. Opps
    "Failed to load the PowerShell CLI"
}



   $vms = get-vm #| ?{$_.name -like "osappprd*"}
   $vmevts = @()
   $vmevt = new-object PSObject
   foreach ($vm in $vms) {
      #Progress bar:
      $foundString = "       Found: "+$vmevt.name+"   "+$vmevt.createdTime+"   "+$vmevt.IPAddress+"   "+$vmevt.createdBy
      $searchString = "Searching: "+$vm.name
      $percentComplete = $vmevts.count / $vms.count * 100
      write-progress -activity $foundString -status $searchString -percentcomplete $percentComplete

      $evt = get-vievent $vm | sort createdTime | select -first 1
      $vmevt = new-object PSObject
      $vmevt | add-member -type NoteProperty -Name createdTime -Value $evt.createdTime
      $vmevt | add-member -type NoteProperty -Name name -Value $vm.name
      $vmevt | add-member -type NoteProperty -Name IPAddress -Value $vm.Guest.IPAddress
      $vmevt | add-member -type NoteProperty -Name createdBy -Value $evt.UserName
      #uncomment the following lines to retrieve the datastore(s) that each VM is stored on
      #$datastore = get-datastore -VM $vm
      #$datastore = $vm.HardDisks[0].Filename | sed 's/\[\(.*\)\].*/\1/' #faster than get-datastore
      #$vmevt | add-member -type NoteProperty -Name Datastore -Value $datastore
      $vmevts += $vmevt
      #$vmevt #uncomment this to print out results line by line
   }
   $vmevts | sort createdTime
