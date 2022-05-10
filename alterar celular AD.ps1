$users = Get-user -Identity celular* -ResultSize unlimited | fl samaccountname,windowsemailaddress,mobilephone


#######CRIAR VARIÁVEIS########
$usuarios = Get-Content -Path C:\temp\usuarios.txt
$celulares = Get-Content -Path C:\temp\celulares.txt
$usuarios.Length
$celulares.Length
$arrbackup = @()

#######PRIMEIRO FOR PARA FAZER BACKUP######## CRIAR UMA VARIÁVEL PARA CADA USUÁRIO DA VARIAVEL USUÁRIO ACIMA ATRAVÉS DO CONTADOR E ADICIONAR
#######MAIS 1 NO FOR#######
for ($i = 0; $i -lt $usuarios.Length; $i++)
{ 


$arrbackup += Get-User -identity $usuarios[$i] | ft samaccountname, mobilephone 


}
$arrbackup | Out-File -FilePath C:\temp\backupcel.txt -Force

########SETAR O NOVO CELULAR ATRAVÉS DOS USUÁRIOS LISTADOS NA VARIÁVEL $USUARIOS, COLOCANDO O ARRAY $I PARA OS CELULARES E USUARIOS COM 
########OPÇÃO DE CONFIRMAÇÃO############
for ($i = 0; $i -lt $usuarios.Length; $i++)
{
    Set-User -Identity $usuarios[$i] -MobilePhone $celulares[$i] -Confirm:$true
}

##########################FIM#############################################


$users = get-user -ResultSize unlimited -SortBy name | ?{$_.mobilephone -ne ""} | ft name,title,mobilephone | Out-File -FilePath  C:\temp\celularallusers.txt

$users.Length

$usuarios | %{Get-User -identity $_ | fl samaccountname, mobilephone}

Add-PSSnapin -Name *Exchange*

Add-PSSnapin -Name *VMWARE*
