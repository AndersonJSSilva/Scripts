$saida = \\unimedrj\netlogon\pacotes\Handle.exe -p dllhost
$saida.Length
$saida = $saida | Select-String -Pattern topsaude
$saida.Length
$saida = $saida | %{($_ -split "\\")[($_ -split "\\").Length -1]}
$saida.Length
$saida | Set-Content \\10.200.5.57\c$\temp\bar02.txt