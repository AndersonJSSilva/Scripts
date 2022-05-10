Import-Module "C:\Program Files\Common Files\Microsoft Lync Server 2013\Modules\Lync\Lync.psd1"
$usuariosadded = $null
$data = ""
$data = (get-date).AddDays(-1).ToString("yyyyMMdd")
$data = "(WhenCreated>=" + $data + "000000.0Z)"
$adusers = Get-CsAdUser -LDAPFilter "$data" | Where-Object {$_.WindowsEmailAddress}
write-host "---------------------------Importar usuarios-------------------------- "
foreach ($lyncuser in $adusers)
{
    if($lyncuser.SamAccountName.Substring(0,1) -match "[a-z]" -and $lyncuser.SamAccountName.Substring(1,1) -match "[0-9]")
    {
       $lyncuser | Enable-CsUser -RegistrarPool "lyncsrvprd01.unimedrj.root" -SipAddressType EmailAddress -SipDomain unimedrio.com.br
       Write-Host "No padrao: "$lyncuser.SamAccountName
       $usuariosadded += $lyncuser.SamAccountName+"`t"+ $lyncuser.WindowsEmailAddress+"`t"+$lyncuser.Description+"`n"
    } else
    {
        if($lyncuser.SamAccountName.Substring(0,1) -match "[a-z]" -and $lyncuser.SamAccountName.Substring(1,1) -match "[a-z]" -and $lyncuser.SamAccountName.Substring(2,1) -match "[0-9]")
        { 
           $lyncuser | Enable-CsUser -RegistrarPool "lyncsrvprd01.unimedrj.root" -SipAddressType EmailAddress -SipDomain unimedrio.com.br
           Write-Host "No padrao: "$lyncuser.SamAccountName
           $usuariosadded += $lyncuser.SamAccountName+"`t"+ $lyncuser.WindowsEmailAddress+"`t"+$lyncuser.Description+"`n"
        } else
        {
            if($lyncuser.SamAccountName.Substring(0,1) -match "[a-z]" -and $lyncuser.SamAccountName.Substring(1,1) -match "[a-z]" -and $lyncuser.SamAccountName.Substring(2,1) -match "[a-z]" -and $lyncuser.SamAccountName.Substring(3,1) -match "[0-9]")
            {            
                $lyncuser | Enable-CsUser -RegistrarPool "lyncsrvprd01.unimedrj.root" -SipAddressType EmailAddress -SipDomain unimedrio.com.br
                Write-Host "No padrao: "$lyncuser.SamAccountName
                $usuariosadded += $lyncuser.SamAccountName+"`t"+ $lyncuser.WindowsEmailAddress+"`t"+$lyncuser.Description+"`n"
            } else {
                Write-Host "Fora do padrao: "$lyncuser.SamAccountName
            }
        }
    }
}

Start-Sleep -s 60
write-host "---------------------------Aplicar politicas-------------------------- " 
foreach ($lyncuser in $adusers)
{
    if (($lyncuser.Description -like "coord*") -OR ($lyncuser.Description -like "assessor*") -OR ($lyncuser.Description -like "gerente*") -OR ($lyncuser.Description -like "diretor*") -or ($lyncuser.Description -like "superin*"))
    {
       #$lyncuser | Grant-CsConferencingPolicy -PolicyName Lib.Conf
       $lyncuser | Grant-CsMobilityPolicy -PolicyName "Lync - Mobility"
       write-host $lyncuser.SamAccountName
    }
}

$corpo = $usuariosadded
if($corpo)
{
    Write-Host "Tem usuarios"
    Send-MailMessage -to "Servidores Windows <_infra-ti_Servidores_windows@unimedrio.com.br>" -from "Lync 2013 <lync2013@unimedrio.com.br>" -subject "Usuarios Importados" -SmtpServer "mail.unimedrio.com.br" -Body $corpo
} else
{
    Write-Host "Sem usuarios"
    Send-MailMessage -to "Servidores Windows <_infra-ti_Servidores_windows@unimedrio.com.br>" -from "Lync 2013 <lync2013@unimedrio.com.br>" -subject "Usuarios Importados" -SmtpServer "mail.unimedrio.com.br" -Body "Nenhum usuario a ser importado"
}

EXIT