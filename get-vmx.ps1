#####################################################################
#          Load VMware Plugins and vCenter Connect                  #
#####################################################################
Add-PSSnapin vmware.vimautomation.core
connect-viserver -server "vmvc-rj2-01.vmware"
#####################################################################
#      Add .VMX (Virtual Machines) to Inventory from Datastore      #
#####################################################################

Get-VMHostStorage -VMHost esxi*.vmware -RescanAllHba

esxcfg-volume -M DS-APP01
esxcfg-volume -M DS-APP02
esxcfg-volume -M DS-FS
esxcfg-volume -M DS-TS01
esxcfg-volume -M DS-TS02
esxcfg-volume -M DS-EXC01
esxcfg-volume -M DS-EXC02
esxcfg-volume -M URJ-DS-REPLICA_LUN_471

# Variables: Update these to the match the environment
$Cluster = "cluster app"
$Datastores = "DS-TS01","DS-TS02","DS-EXC02","DS-EXC01","DS-APP02","DS-APP01","DS-FS","URJ-DS-REPLICA_LUN_471"
#[array]$Datastores = "DS-APP01"
$VMFolder = "Migracao"
$ESXHost = Get-Cluster $Cluster | Get-VMHost | select -First 1
#$ESXHost = Get-Cluster $Cluster | Get-VMHost esxiapp-rj2-03*| select -First 1
 
foreach($Datastore in $Datastores) {
# Searches for .VMX Files in datastore variable
$ds = Get-Datastore -Name $Datastore | %{Get-View $_.Id}
$SearchSpec = New-Object VMware.Vim.HostDatastoreBrowserSearchSpec
$SearchSpec.matchpattern = "*.vmx"
$dsBrowser = Get-View $ds.browser
$DatastorePath = "[" + $ds.Summary.Name + "]"
 
# Find all .VMX file paths in Datastore variable and filters out .snapshot
$SearchResult = $dsBrowser.SearchDatastoreSubFolders($DatastorePath, $SearchSpec) | where {$_.FolderPath -notmatch ".snapshot"} | %{$_.FolderPath + ($_.File | select Path).Path}
 
# Register all .VMX files with vCenter
foreach($VMXFile in $SearchResult)
{
    #New-VM -VMFilePath $VMXFile -VMHost $ESXHost -Location $VMFolder -RunAsync
    write-host 'New-VM -VMFilePath '"'$VMXFile'"' -VMHost $ESXHost -Location $VMFolder -RunAsync'
}
}

