#Limpeza de Variáveis
$MáquinasVM = @()

##Conexão com o Vmvcenter
$ModuloVM = Add-PSSnapin *vmware*
$ConexaoVCenter = Connect-VIServer -Server vmvcenter -Protocol https -User unimedrj\m47333 -Password SecureString

##Conexão com os Sites
$Datacenter = Get-Datacenter -name *

##Busca por Máquinas Virtuais em cada Site
Foreach($site in $Datacenter)
{
$MáquinasVM += Get-VM -Location $site
}
$MáquinasVM | Sort-Object name | select name, host | ?{$_.name -like "webdbprd01"}
