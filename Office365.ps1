Get-MessageTrace -RecipientAddress rogerio.passos@unimedrio.com.br -StartDate 03/15/2019 -EndDate 03/20/2019 | Get-MessageTraceDetail

Install-Module -Name AzureAD

Install-Module MSOnline

Connect-MsolService

$UserCredential = Get-Credential

$Session = New-PSSession -ConfigurationName Microsoft.Exchange -ConnectionUri https://outlook.office365.com/powershell-liveid/ -Credential $UserCredential -Authentication Basic -AllowRedirection

Import-PSSession $Session -DisableNameChecking

Get-DistributionGroup -Identity _Infra-TI_Servidores_Windows | select *bypa*
Set-DistributionGroup -Identity _Infra-TI_Servidores_Windows -ManagedBy "rogerio.passos@unimedrio.com.br" -BypassSecurityGroupManagerCheck

Remove-PSSession $Session

Get-MessageTrace -SenderAddress noreply@unimedrio.com.br -StartDate "05/19/2019 00:01AM" -EndDate "06/06/2019 11:59PM" | Out-GridView 

Get-MessageTrace -RecipientAddress Ouvidoria.ReclCadastro@unimedrio.com.br -StartDate "05/19/2019 00:01AM" -EndDate "05/21/2019 11:59PM" | Out-GridView 

Get-MailboxFolderStatistics -Identity m17892 | select name, FolderSize 

Get-Mailbox | select maxsen*,maxrec*

Get-Mailbox | Set-Mailbox –MaxSendSize 75 MB –MaxReceiveSize 75 MB

New-DistributionGroup -Name "_sieurehhmg" -Alias _sieurehhmg -MemberJoinRestriction Close -PrimarySmtpAddress sieurehhmg@unimedrio.com.br | Set-DistributionGroup -HiddenFromAddressListsEnabled $True

Get-MailboxFolderStatistics -FolderScope all -Identity decisao_judicial@unimedrio.com.br | where {$_.identity -eq "decisao_judicial@unimedrio.com.br\Início do Repositório de Informações"} | select ItemsInFolderAndSubfolders, FolderAndSubfolderSize

Start-ManagedFolderAssistant -Identity rogerio.passos@unimedrio.com.br


Add-DistributionGroupMember -Identity "_SIE_Usuários" -Member "vania.neri@unimedrioempreendimentos.com.br"

####################Habilitar Idioma#############################################################
Set-MsolUser -UserPrincipalName Felipe.Moura-stefanini@unimedrioempreendimentos.com.br -UsageLocation BR

#######################################Habilitar Licença###############################################################
Set-MsolUserLicense -UserPrincipalName Felipe.Moura-stefanini@unimedrioempreendimentos.com.br     -AddLicenses "unimedrio365:EXCHANGESTANDARD"

######################################Change License########################################################################
Set-MsolUserLicense -UserPrincipalName juliana.batista@unimedrio.com.br –AddLicenses       “unimedrio365:STANDARDPACK“ –RemoveLicenses “unimedrio365:EXCHANGESTANDARD“                                                   

##################################################################################################################################################

get-mailbox | Set-MailboxRegionalConfiguration -Language 1046 -DateFormat "dd/MM/yyyy" -TimeFormat "HH:mm" -TimeZone "E. South America Standard Time"

Get-MailboxRegionalConfiguration -Identity rogerio.passos@unimedrio.com.br

########################################Desabilitar automapping#############################
Add-MailboxPermission -Identity DecisaoJudicial2016@unimedrio.com.br -User alex.wernay@unimedrio.com.br -AccessRights FullAccess -AutoMapping:$false


Get-DistributionGroup -identity _ressarcimentosus@unimedrio.com.br | Set-DistributionGroup -RequireSenderAuthenticationEnabled $False 

