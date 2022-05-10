Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin
$Mbxs = Get-Mailbox -ResultSize unlimited
Write-Host "Qtd total de caixas: "$Mbxs.count
$var = 0
foreach($mbx in $Mbxs)
{
    $user = Get-MailboxStatistics -Identity $mbx.Identity
    try {$var += $user.TotalItemSize.Value.ToMB()}catch{}
}
Write-Host "Tamanho total das caixas: "$var "MB"

#Get-MailboxStatistics -Server excboxprd | Ft DisplayName,@{ expression={$_.TotalItemSize.Value.ToMB()}},ItemCount | Export-Csv C:\saida.csv



Add-MailboxPermission -Identity 'CN=restore,CN=Users,DC=unimedrj,DC=root' -User 'UNIMEDRJ\M41718' -AccessRights 'FullAccess'



Get-PublicFolderClientPermission -Identity "\NON_IPM_SUBTREE\EFORMS REGISTRY\Organization(409)"
Get-PublicFolderClientPermission -Identity "\NON_IPM_SUBTREE\EFORMS REGISTRY\Organization(409)" | ?{$_.user -like "*exc*"}| ft -AutoSize

Add-PublicFolderClientPermission -User unimedrj\tr1850 -AccessRights owner -Identity "\NON_IPM_SUBTREE\EFORMS REGISTRY\Organization(409)"
Add-PublicFolderClientPermission -User unimedrj\_ExcFormsAdmUsers -AccessRights owner -Identity "\NON_IPM_SUBTREE\EFORMS REGISTRY\Organization(409)"

Remove-PublicFolderClientPermission -User unimedrj\tr1850 -Identity "\NON_IPM_SUBTREE\EFORMS REGISTRY\Organization(409)" -AccessRights owner


new-DistributionGroup -Name '_ExcFormsAdmUsers' -Type 'Security' -OrganizationalUnit 'unimedrj.root/_Barra/Grupo de Segurança e Distribuição' -SamAccountName '_ExcFormsAdmUsers' -Alias '_ExcFormsAdmUsers'
Get-DistributionGroupMember -Identity _excformsadmusers
Add-DistributionGroupMember -Identity _excformsadmusers -Member m41718
Remove-DistributionGroupMember -Identity _excformsadmusers -Member m41718 -Confirm:$false



$name = 'Teste DL'
$samaccountname = $name -replace " ","."
$alias = $name -replace " ","."
$ou = 'unimedrj.root/_Barra'
New-DistributionGroup -Name $name -OrganizationalUnit $ou -Type security -SamAccountName $samaccountname -Alias $alias

Get-DistributionGroup | ? {$_.name -like "$name*"} 

function SendOnBeHalf-DL ($matricula)
{
    $conta = Get-mailbox $matricula
    $DL = Get-DistributionGroup "senha.ramal"
    $DL.GrantSendOnBehalfTo += $conta.DistinguishedName
    Set-DistributionGroup "senha.ramal" -GrantSendOnBehalfTo $DL.GrantSendOnBehalfTo
}
SendOnBeHalf-DL -matricula "m41718"


$DL.GrantSendOnBehalfTo | select name
Get-DistributionGroup $DL | fl name,grant* -Expand 


