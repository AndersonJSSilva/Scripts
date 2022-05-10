$cred = Get-Credential -Credential "administrator"
$vm = get-vm tsaudeappprd05
$net = $vm | Get-NetworkAdapter
$net | Set-NetworkAdapter -StartConnected $false -Confirm:$false
Start-VM -VM $vm

 do{
    Start-Sleep -Seconds 20;
    $vm = Get-VM $vm.name
    $toolsStatus = $vm.extensionData.Guest.ToolsStatus;
}while($toolsStatus -ne "toolsOK");
write-host servidor online -foreground green


$script = "c:\windows\system32\sysprep\sysprep.exe /generalize /oobe /reboot"
#$user = "administrator"
#$pass = ConvertTo-SecureString '$m4n3t4r#717' -AsPlainText -Force
Invoke-vmscript -scripttext $script -VM $VM.name -GuestCredential $cred -scripttype Bat | Out-null

 do{
    Start-Sleep -Seconds 20;
    $vm = Get-VM $vm.name
    $toolsStatus = $vm.extensionData.Guest.ToolsStatus;
}while($toolsStatus -ne "toolsOK");
write-host servidor online -foreground green

$net | Set-NetworkAdapter -StartConnected $true -Connected $true -Confirm:$false


