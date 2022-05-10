function New-RandomPassword
{
    do
    {
        $passLetras = (97..122) + (65..90) | Get-Random -Count 5 | % {[char]$_} # minusculas e minusculas
        $passCS = [Char[]]"!#$&*@"| Get-Random -Count 1 | % {[char]$_} #char specials
        $passNum = (48..57) | Get-Random -Count 2 | % {[char]$_} # numeros
        
        $pass = $passLetras + $passNum
        $pass = -join $pass

        $seed = $(Get-Random -Maximum ($pass.Length+1) -Minimum 0)
	    $pass = $pass.Insert($seed,$passCS)

        #$pass = $passLetras + $passCS + $passNum
        #Write-Host $pass -ForegroundColor Yellow
        if(($pass -cmatch "[A-Z]") -and ($pass -cmatch "[a-z]") ) { return -join $pass } else { $pass = $null }
    
    }
    while(!$pass)
    
}

$users = Get-ADUser -Filter {(company -like "topdown") -and (enabled -eq $true)} -Properties * | select name, samaccountname, mail, enabled, whencreated
#$users | Sort-Object whencreated | ft 
$users.Count
$saida = "Nome,Matricula,Senha`n"
foreach($u in $users)
{
    $password = New-RandomPassword
    $saida = $saida + $u.name +","+$u.samaccountname+","+$password+"`n"
    Set-ADAccountPassword -Identity $u.samaccountname -NewPassword (ConvertTo-SecureString -AsPlainText $password -Force) 
}
$saida | Set-Content c:\temp\topdown.csv -Encoding Unicode
$csv = import-csv c:\temp\topdown.csv -Encoding Unicode
#$csv | %{$_.nome;Test-ADAuthentication -userlogin $_.matricula -userpassword $_.senha}
Send-Mailmessage -From "carlos.david@unimedrio.com.br" -To "anderson.assumpcao@unimedrio.com.br" -Subject "Topdown - Reset Senha de rede" -Attachments c:\temp\topdown.csv -Body "Em anexo arquivo com as respectivas senhas" -Priority Normal -SmtpServer "mail.unimedrio.com.br" -Encoding unicode

