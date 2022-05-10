Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin

$nome = ""
$manager = ""
$matriculas = @()
$samaccountname = $nome -replace " ",""

##### criar grupo de distribuicao
if($nome){New-DistributionGroup -Name $nome -OrganizationalUnit 'unimedrj.root/_Barra/Grupo de Segurança e Distribuição' -SAMAccountName $samaccountname -Type "Distribution"}
Start-Sleep 15

#### Adiciona o Membros e manager
if($matriculas){$matriculas | %{Add-DistributionGroupMember -Identity $samaccountname -member $_ }}
if($manager){Set-DistributionGroup -Identity $samaccountname -ManagedBy $manager}
Start-Sleep 15

### revisa os membros e manager
if($nome){Write-Host Membros: -ForegroundColor Yellow
Get-DistributionGroupMember -Identity $samaccountname}
if($manager){Write-Host Gerenciado Por: -ForegroundColor Yellow
Get-DistributionGroup -Identity $samaccountname | select ManagedBy}