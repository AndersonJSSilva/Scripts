Connect-MsolService
Connect-Azuread

#Variaveis de Hora

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

Start-Transcript -Path C:\Temp\REMOVE_LIC_DISABLE_ACC_$date_file2.log -Append

$lista = Import-Csv "C:\temp\removeHumberto.csv" #Gerar CSV a partir do XLS, colocar na primeira linha UserPrincipalName como título

foreach($u in $lista){

    $User = Get-MsolUser -UserPrincipalName $u.UserPrincipalName

    $accountEnabled = (Get-AzureADUser -ObjectId $user.UserPrincipalName).AccountEnabled
    If ($accountEnabled) {
          Set-AzureADUser -ObjectID $user.UserPrincipalName -AccountEnabled $false
          echo "$($user.DisplayName) Dasabilitado"
     } Else {
            Write-Host "$($user.DisplayName) Já encontra-se Desabilitado"
    }

    Echo ".........."

    echo "Processando Licenças para os Usuário: $($user.DisplayName)"
    try { $user = Get-MsolUser -UserPrincipalName $u.UserPrincipalName -ErrorAction Stop }
    catch { continue }

    Echo ".........."

    $SKUs = @($user.Licenses)
    if (!$SKUs) { echo "Nenhuma Licença encontrada para o usuário..." ; continue}

    foreach ($SKU in $SKUs) {
      if (($SKU.GroupsAssigningLicense.Guid -ieq $user.ObjectId.Guid) -or (!$SKU.GroupsAssigningLicense.Guid)) {
      echo "Removendo Licença $($Sku.AccountSkuId)"
      Set-MsolUserLicense -UserPrincipalName $u.UserPrincipalName -RemoveLicenses $SKU.AccountSkuId
      }
      else {
      Write-Verbose "Licença $($Sku.AccountSkuId) está atribuída via grupo, use o AD para remove-la"
      continue
      }
    }
    
}
Stop-Transcript