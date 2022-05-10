[array]$usersInfo = Import-Csv C:\temp\ADUpdate.csv -Delimiter ";"

#Set-Content c:\temp\saida.csv "matricula;primeironome;sobrenome;nome;nomedeexibicao;localidade;Area;cargo;empresa;email;numcelularCorporativo;numtelefone;matriculagestor;gestor"]
$atualizados = @()
$mudaremail = @()
function AtualizaUsuario($usuarioAD, $usuarioCSV)
{
$usuarioAD | Set-ADUser -DisplayName $usuarioCSV.nomedeexibicao`        -GivenName $usuarioCSV.primeironome `        -Surname $usuarioCSV.sobrenome`        -Office $usuarioCSV.localidade`        -Company $usuarioCSV.empresa`        -Department $usuarioCSV.Area`        -Description $usuarioCSV.cargo`        -Title $usuarioCSV.cargo`        -Manager $usuarioCSV.matriculagestor
        if($usuarioCSV.numcelularCorporativo)          {$usuarioAD | Set-ADUser -MobilePhone $usuarioCSV.numcelularCorporativo}else{$usuarioAD | Set-ADUser -MobilePhone $null}
        if($usuarioCSV.numtelefone)                    {$usuarioAD | Set-ADUser -OfficePhone $usuarioCSV.numtelefone}          else{$usuarioAD | Set-ADUser -OfficePhone $null}
        if($usuarioAD.cn -cnotlike $usuarioCSV.nome)   {$usuarioAD | Rename-ADObject -NewName $usuarioCSV.nome}
}

foreach ($user in $usersInfo)
{
    $tmp = Get-ADUser -Identity $user.matricula -Properties *
    if($tmp -and (($tmp.GivenName -eq $user.primeironome) -and ($tmp.Surname -eq $user.sobrenome)))
    {
        #AtualizaUsuario -usuarioAD $tmp -usuarioCSV $user
        $atualizados += $user
        #Write-Host Nome e sobrenome iguais $user.nome -BackgroundColor Green

    }else
    {
        
        Write-Host Nome e sobrenome diferentes : $user.primeironome $user.sobrenome ->  $tmp.GivenName $tmp.Surname -BackgroundColor red
        $mudaremail += $user
        <#if((Get-Mailbox -identity $user.matricula).EmailAddressPolicyEnabled)
        {
            Set-Mailbox -Identity $user.matricula -EmailAddressPolicyEnabled $false
            AtualizaUsuario -usuarioAD $tmp -usuarioCSV $user
            $mudaremail += $user
        }else
        {
            #AtualizaUsuario -usuarioAD $tmp -usuarioCSV $use
        }#>
            
    } 
    $tmp = $null   

}

$atualizados.count
$mudaremail.count

$mudaremail | ft nome