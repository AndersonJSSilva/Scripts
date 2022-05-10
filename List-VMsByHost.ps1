$vCenterIP = "vmvcenter.unimedrj.root"
Add-PSSnapin VMware.VimAutomation.Core
Connect-VIServer $vCenterIP

########################lista vms de cada host
$saida = @()
$hosts = get-vmhost | Sort-Object name
foreach($server in $hosts)
{
    $saida += $server | get-vm | select vmhost,name
}
$saida | Export-Csv "\\arqprd01\suporte$\1.SUPORTE\Auditoria_Controle(Windows)\VMs_x_Hosts\VMhostxVMs.csv" -Encoding Unicode

Disconnect-VIServer -Confirm:$false