$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP -WarningAction 0 >$null 2>&1

<#
$computers = Get-ADComputer -Filter {name -like "*"} -Properties * -SearchBase  "OU=PILOTO-WSUS,OU=Contigencia,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers += Get-ADComputer -Filter {name -like "*"} -Properties * -SearchBase  "OU=PILOTO-WSUS,OU=Desenvolvimento,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers += Get-ADComputer -Filter {name -like "*"} -Properties * -SearchBase  "OU=PILOTO-WSUS,OU=Homologacao,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers += Get-ADComputer -Filter {name -like "*"} -Properties * -SearchBase  "OU=PILOTO-WSUS,OU=Producao,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers.Count

$computers = Get-ADComputer -Filter {name -like "*"} -Properties * -SearchBase  "OU=CTG-AUTOMATICO,OU=Contigencia,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers += Get-ADComputer -Filter {name -like "*"} -Properties * -SearchBase  "OU=DSV-AUTOMATICO,OU=Desenvolvimento,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers += Get-ADComputer -Filter {name -like "*"} -Properties * -SearchBase  "OU=HMG-AUTOMATICO,OU=Homologacao,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers += Get-ADComputer -Filter {name -like "*"} -Properties * -SearchBase  "OU=PRD-AUTOMATICO,OU=Producao,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers.Count
#>
##################################### Coleta os servidores no AD #####################################

$computers = Get-ADComputer -Filter {name -like "*"} -Properties description -SearchBase  "OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"
$computers.Count
#$computers | select name, description

################################ Cria Snapshot VMWARE-PILOTO-WSUS ################################################

$timestamp = get-date -Format "yyyy-MM-dd hh:mm:ss"
$Snapshotname = "Windows Update "+$timestamp
$description = $Snapshotname +" "+ "Atualizações automáticas PILOTO-WSUS"

foreach($server in $computers)
{
    if($server.Description -eq "VMWARE-PILOTO-WSUS")
    {
        $server.Name
        New-Snapshot -VM $server.Name -Name $Snapshotname -Description $description -RunAsync
    }
}

################################################################################################

################################ Cria Snapshot VMWARE-AUTOMATICO-WSUS ##########################

$timestamp = get-date -Format "yyyy-MM-dd hh:mm:ss"
$Snapshotname = "Windows Update "+$timestamp
$description = $Snapshotname +" "+ "Atualizações automáticas AUTOMATICO-WSUS"

foreach($server in $computers)
{
    if($server.Description -eq "VMWARE-AUTOMATICO-WSUS")
    {
        $server.Name
        New-Snapshot -VM $server.Name -Name $Snapshotname -Description $description -RunAsync
    }
}

################################################################################################


################################## Deletar Snapshot ############################################
$snapshots = get-vm | get-snapshot
$snapshots | ft vm,name,Created,  @{Label="SizeMB";Expression={"{0:N2}" -f ($_.sizemb)}}
foreach($snapshot in $snapshots){if($snapshot.name -like "Windows Update 2017-05-15 05:16:04"){Remove-Snapshot -Snapshot $snapshot -RunAsync -Confirm:$false}}
################################################################################################