Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.snapin


##### criar grupo de distribuicao
New-DistributionGroup -Name "_TI_RightnowChat" -OrganizationalUnit 'unimedrj.root/_Barra/Grupo de Segurança e Distribuição' -SAMAccountName "_TI_RightnowChat" -Type "Distribution"

Set-DistributionGroup -identity "_TI_RightnowChat" -ManagedBy tr2313 -MemberDepartRestriction Closed -RequireSenderAuthenticationEnabled $true

get-aduser -filter {mail -eq "Cleide.Nonato-level4@unimedrio.com.br"} -Properties * | select name, mail, samaccountname

Add-DistributionGroupMember -identity "_TI_RightnowChat" -Member M71412
get-DistributionGroupMember -identity "_TI_RightnowChat"

$users = @(
"Cleide.Nonato-level4@unimedrio.com.br","sheila.costa-stefanini@unimedrio.com.br","Vania.Vargas@unimedrio.com.br","katia.mathias@unimedrio.com.br",
"Marcelo.Costa@unimedrio.com.br","Rozanira.Loureiro@unimedrio.com.br","Thais.Bouth@unimedrio.com.br","Jean.Oliveira@unimedrio.com.br",
"Rafaela.Pinto@unimedrio.com.br","Indaiara.Santos@unimedrio.com.br","Izabel.Teixeira@unimedrio.com.br",
"Giani.Lima@unimedrio.com.br","Fernanda.Teodoro@unimedrio.com.br","Paula.Carrinhanha@unimedrio.com.br")

$saida = @()
$users | %{$saida += get-aduser -filter {mail -eq $_} -Properties * |select samaccountname}

$saida | %{Add-DistributionGroupMember -identity "_TI_RightnowChat" -Member $_.samaccountname}


get-DistributionGroup -identity "_TI_RightnowChat" | select * 

Set-DistributionGroup -Identity "_TI_RightnowChat" -MemberDepartRestriction Closed