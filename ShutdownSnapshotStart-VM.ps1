$vms = get-vm -name scsm*
$vms
$numvms = $vms.Count
$vms | Shutdown-VMGuest -Confirm:$false
Start-Sleep 10
$vmsoff = get-vm -name scsm* | ?{$_.PowerState -eq "poweredoff"}
while($vmsoff.Count -ne $numvms)
{
    Start-Sleep 10
    $vmsoff = get-vm -name scsm* | ?{$_.PowerState -eq "poweredoff"}
    Write-Host Aguardando VMs desligarem.. -ForegroundColor Yellow
}
$vmsoff
Start-Sleep 5
$vms | New-Snapshot -Name "Deploy Novo Portal de TI" -Confirm:$false
$vms | Start-VM

#$snaps  = Get-VM -Name scsm* | Get-Snapshot
#$snaps | Remove-Snapshot -RunAsync -Confirm:$false