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
        if(($pass -cmatch "[A-Z]") -and ($pass -cmatch "[a-z]") ) { return -join $pass } else { $pass = $null }    
    }
    while(!$pass)   
}
$trs = Get-ADUser -filter * | ?{$_.samaccountname.length -eq 6 -and $_.SamAccountName.Substring(0,2) -eq "tr" -and $_.SamAccountName.Substring(2,1) -match "[0-9]"} | select samaccountname
$temp = @()
foreach($tr in $trs){$temp += [int]($tr.samaccountname -replace "tr","")}
#ultimo tr
Write-Host O último TR é o: tr($temp | Sort-Object -Descending)[0] -ForegroundColor Magenta
#proximo tr
$novologin = "tr"+ (($temp | Sort-Object -Descending)[0] + 1)
Write-Host O novo TR será o: $novologin -ForegroundColor Yellow

$ou = "OU=sem_acesso_ad,OU=_Usuarios_Terceiros_Bloqueados,DC=unimedrj,DC=root"
$passtemp = New-RandomPassword
Write-Host A senha é: $passtemp -ForegroundColor green
$password = convertto-securestring $passtemp -asplaintext -force

$nome = $sobrenome = $cargo = $area = $empresa = $mail = $escritorio = $displayname = $gerente = $null
do{$nome = Read-Host 'Digite o nome'}while($nome -eq $null)
do{$sobrenome = Read-Host 'Digite o sobrenome'}while($sobrenome -eq $null)
do{$cargo = Read-Host 'Digite a cargo'}while($cargo -eq $null)
do{$area = Read-Host 'Digite a area'}while($area -eq $null)
do{$empresa = Read-Host 'Digite a empresa'}while($empresa -eq $null)
do{$mail = Read-Host 'Digite o email'}while($mail -eq $null)
do{$gerente = Read-Host 'Digite a matricula do Gerente'}while($gerente -eq $null)
$escritorio = "Empresa Externa"
$displayname = $nome + " " + $sobrenome + " - " + $area

New-ADUser -AccountPassword $password -SamAccountName $novologin -Enabled $false -givenName $nome -name "$nome $sobrenome" -Surname $sobrenome  -OtherAttributes @{'description'="$cargo";'title'="$cargo";'mail'="$mail"} -Department $area -Company $empresa -Office $escritorio -Path $ou -displayname $displayname 
Get-aduser -Identity $novologin | Set-ADUser -Manager $gerente



