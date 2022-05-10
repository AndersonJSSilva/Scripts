# ------------------------------------------------------------------ 
# space to import all modules 
ipmo ActiveDirectory # load module from Active Directory
#-------------------------------------------------------------------

$date = Get-Date
[string]$dia = $date
[string]$mes = $date
[string]$ano = $date
[string]$hora = $date
[string]$minuto = $date
[string]$segundo = $date

[string]$date_file1 = $dia.substring(3,2) + $mes.substring(0,2) + $ano.substring(6,4)
[string]$date_file = $dia.substring(3,2) + "/" + $mes.substring(0,2) + "/" + $ano.substring(6,4)
[string]$date_file2 = $dia.substring(3,2) + $mes.substring(0,2) + $ano.substring(6,4) + "_" + $hora.substring(11,2) + $minuto.substring(14,2) + $segundo.substring(17,2)

$output_File = "C:\Scripts\Inativos60Dias_$date_file2.txt"

#############################################################################################################################################################
# Hearder of the output file
$hearder = "Linha ;Login;Nome;DisplayName;Dominio;Descrição;Empresa;Escritório;Cargo;Departamento;HomePage(Historico Anterior);Login Habilitado;Gerente;Data da Criação;Último Logon;MemberOf;DistinguishedName;AccountExpirationDate;logonCount;PasswordExpired;PasswordNeverExpires;Execução do Script"
echo $hearder >> $Output_File

#############################################################################################################################################################
#Dias sem logar
$NumberDays = (get-date).AddDays(-60)
$NDaysCreated = (get-date).AddDays(-30)
 Write-Output "-----PESQUISANDO E SALVANDO OS USUÁRIOS ELEGÍVEIS...-----"
$list_user = Get-ADUser -filter {((lastlogondate -le $NumberDays) -OR (lastlogondate -notlike "*")) -AND (Created -le $NDaysCreated) -AND (Title -notlike "SISTEMA") -AND (Title -notlike "PRESIDENTE") -AND (Title -notlike "Chief Operating Officer") -AND (Title -notlike "SERVICO") -AND (enabled -eq $True)} -SearchBase "DC=sascar,DC=local" -properties SamAccountName |select SamAccountName

if ($list_user -ne $null) {
for ($i=0; $i -lt $list_user.Length;$i++){
$user = $list_user[$i].SamAccountName
$b = $i
$get_user_info = Get-ADUser $user -properties *

$1 = $get_user_info.SamAccountName
$2 = $get_user_info.CN
$3 = $get_user_info.DisplayName
$4 = $get_user_info.UserPrincipalName
$5 = $get_user_info.Description
$6 = $get_user_info.Company
$7 = $get_user_info.Office
$8 = $get_user_info.Title
$9 = $get_user_info.Department
$10 = $get_user_info.HomePage
$11 = $get_user_info.Enabled
$12 = $get_user_info.Manager
$13 = $get_user_info.Created
$14 = $get_user_info.LastLogonDate
$15 = $get_user_info.MemberOf
$16 = $get_user_info.DistinguishedName
$17 = $get_user_info.AccountExpirationDate
$18 = $get_user_info.logonCount
$19 = $get_user_info.PasswordExpired
$20 = $get_user_info.PasswordNeverExpires

#############################################################################################################################################################
#Adiciona historico no Homepage, Desabilita o usuário e Envia Email
 Write-Output "-----ADICIONA HISTÓRICO NO HOMEPAGE E DESABILITA O USUÁRIO - $1...-----"
Set-ADUser $get_user_info.SamAccountName -Homepage "INATIVO - Desativado em: $date" 
Disable-ADAccount -Identity $get_user_info.SamAccountName
echo "$b;$1;$2;$3;$4;$5;$6;$7;$8;$9;$10;$11;$12; $13; $14;$15;$16; $17;$18;$19;$20;$date "  >> $Output_File
}}
else{
 Write-Output "-----NÃO LOCALIZADO USUÁRIOS ELEGÍVEIS.-----"
 echo "NÃO LOCALIZADO USUÁRIOS ELEGÍVEIS $Date" >> $Output_File
}

##Envio de Email
$De = "ScriptAD@sascar.com.br"
$Para = "adonis.oliveira.ext@sascar.com.br","luiz.oliveira@sascar.com.br","rodrigo.lehrer.ext@sascar.com.br","clayton.baciuk@sascar.com.br","Alex.ferreira.ext@sascar.com.br","felipe.silveira.ext@sascar.com.br"
$Assunto = "Report 60 Dias"
$Mensagem = "Usuarios bloqueados com 60 dias sem utilizacao"
$SMTP = "correio.sascar.com.br"
$Porta = "587"
Send-MailMessage -From $De -To $Para -Subject $Assunto -Body $Mensagem -Attachments C:\Scripts\Inativos60Dias_$date_file2.txt -SmtpServer $SMTP -Port $Porta

 Write-Output "-----SCRIPT FINALIZADO!-----"
#############################################################################################################################################################