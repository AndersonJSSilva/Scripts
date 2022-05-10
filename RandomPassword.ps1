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
        Write-Host $pass -ForegroundColor Yellow
        if(($pass -cmatch "[A-Z]") -and ($pass -cmatch "[a-z]") ) { return -join $pass } else { $pass = $null }
    
    }
    while(!$pass)
    
}


New-RandomPassword 



$m4n3t4r#717
