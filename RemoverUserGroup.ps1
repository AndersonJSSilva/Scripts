#Limpeza de Variáveis
$UsuariosVPN = @();
$UsuarioVPN = @();
$DisableUser = @();
$Teste = @();
$RemoverUser = @();

#Remoção de Usuários Desabilitados de Grupo VPN DUO HITSS
$UsuariosVPN = Get-adgroupmember VPN_Duo_Hitss | select samaccountname
Foreach($UsuarioVPN in $UsuariosVPN){
$DisableUser = Get-ADUser -Identity $UsuarioVPN.samaccountname | Select Enabled
If ($DisableUser.Enabled -eq $False){
$Teste += $UsuarioVPN.samaccountname
##$RemoverUser = Get-ADGroup -Identity VPN_Duo_Hitss | Remove-ADGroupMember -Confirm:$False -member $UsuarioVPN.samaccountname
}}