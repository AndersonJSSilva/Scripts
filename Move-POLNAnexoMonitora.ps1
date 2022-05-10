$files04 = $null
$files05 = $null
$files04 = Get-Item "\\polnappprd04\c$\ANEXO_MONITORA\anexo_monitora\*.*" -Exclude "02BFC0A81E57*"
write-host $files04.count arquivos no servidor polnappprd04 -BackgroundColor Black -ForegroundColor Red
$files05 = Get-Item "\\polnappprd05\c$\ANEXO_MONITORA\anexo_monitora\*.*" -Exclude "02BFC0A81E57*"
write-host $files05.count arquivos no servidor polnappprd05 -BackgroundColor Black -ForegroundColor Red

#Realiza backup antes de mover
write-host polnappprd04 -ForegroundColor Yellow
foreach($file in $files04)
{
    write-host "backupeando: "$file.Name
    Copy-Item -path $file -Destination "\\supwinprd01\c$\temp\anexo\04\"
}
#Move os arquivos para \\arqprd01\arq_neo\arquivos\ANEXO_MONITORA
foreach($file in $files04)
{
    write-host "Movendo: "$file.Name
    Move-Item -Path $file -Destination \\arqprd01\arq_neo\arquivos\ANEXO_MONITORA -Force
}

#Realiza backup antes de mover
write-host polnappprd05 -ForegroundColor yellow
foreach($file in $files05)
{
    write-host "backupeando: "$file.Name
    Copy-Item -path $file -Destination "\\supwinprd01\c$\temp\anexo\05\"
}
#Move os arquivos para \\arqprd01\arq_neo\arquivos\ANEXO_MONITORA
foreach($file in $files05)
{
    write-host "Movendo: "$file.Name
    Move-Item -Path $file -Destination \\arqprd01\arq_neo\arquivos\ANEXO_MONITORA -Force
}


<#

#Verificando arquivos no destino
foreach($file in $files04)
{
    write-host "Verificando: "$file.Name
    $filetmp = $file.Name
    get-Item "\\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\$filetmp"
}
#Verificando arquivos no destino
foreach($file in $files05)
{
    write-host "Verificando: "$file.Name
    $filetmp = $file.Name
    get-Item "\\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\98989051_SCAN_FAT_150.pdf"
}

#################################################################################################

$arquivo = "*ADNA MARIA*"

Get-Item "\\polnappprd04\c$\ANEXO_MONITORA\ANEXO_MONITORA\$arquivo"
copy-Item "\\polnappprd04\c$\ANEXO_MONITORA\ANEXO_MONITORA\$arquivo" -Destination "C:\temp\anexo\04\"
Get-Item "C:\temp\anexo\04\$arquivo"
move-Item -Path "\\polnappprd04\c$\ANEXO_MONITORA\ANEXO_MONITORA\$arquivo" -Destination \\arqprd01\arq_neo\arquivos\ANEXO_MONITORA -Force
Get-Item "\\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\$arquivo"
Get-Item "\\polnappprd04\c$\inetpub\wwwroot\prestador2\"
#>
####################################################################################################