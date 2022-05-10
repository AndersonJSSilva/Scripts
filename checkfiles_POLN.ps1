$files04n = $null
$files05n = $null
$files04n = Get-Item "c:\temp\anexo\04\*.*" -include "02BFC0A81E57_*"
write-host $files04n.count arquivos no servidor polnappprd04 -BackgroundColor Black -ForegroundColor Red
$files05n = Get-Item "c:\temp\anexo\05\*.*" -include "02BFC0A81E57_*"
write-host $files05n.count arquivos no servidor polnappprd05 -BackgroundColor Black -ForegroundColor Red
$files04e05 = $files04n 
$files04e05 += $files05n
$files04e05.count
#$files04e05 | select lastwritetime, name | Export-Csv c:\temp\arquivosnaorenomeados.csv -Encoding Unicode

$filesnew= @()
$filesquery = Get-Content C:\temp\anexo\resultquery.txt
foreach($file in $torename)
{
    
    $filetofind = ($file.name).Substring(13)
    foreach($line in $filesquery)
    {
       if( ($file.name).Substring(13) -eq ($line).Substring(9))
       {
            write-host $file.name "---" $line
            $filesnew += $line
       }       
    }
}
$filesnew.count


$filein = @()
foreach($file in $filesnew)
{
    $filename = $file
    if(!(Test-Path "\\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\$filename"))
    {
        $file
        $filein  += $file 
    }

}
$filein.Length
$filein | out-file -FilePath C:\temp\arquivosmovidos09092014.txt -Encoding Unicode

### copia para pasta tomove para ser renomeado
foreach($file in $filein)
{
    $str = ($file).Substring(9)
    if(Test-Path "C:\temp\anexo\04\02BFC0A81E57_$str")
    {
        Copy-Item -Path "C:\temp\anexo\04\02BFC0A81E57_$str" -Destination C:\temp\anexo\tomove
    }else{
        Copy-Item -Path "C:\temp\anexo\05\02BFC0A81E57_$str" -Destination C:\temp\anexo\tomove
    }

}

### renomeia trocando o MAC address pelo numero do pedido correspondente de acordo com o resultado da query no BD
$torename = get-item C:\temp\anexo\tomove\*.*
foreach($file in $torename)
{
    $srt = $file.name
    $srt = $srt -replace "02BFC0A81E57_",""
    foreach($i in $filesnew)
    {
        if(($file.name).Substring(13) -eq ($i).Substring(9))
        {
            $tmp = ($i).Substring(0,9) + ($file.name).Substring(13)
            Rename-Item -Path $file -NewName $tmp

        }
        
    }
}

# verificar se os aqrquivos
$tocheck = get-item C:\temp\anexo\tomove\*.*
$i=0
foreach($file in $filein)
{
   $filename = $file
   if(!(Test-Path "\\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\$filename"))
    {
        write-host $file " nao existe"
        $i++ 
        Copy-Item "c:\temp\anexo\tomove\$file" -Destination "\\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\"
    }
    else
    {
         write-host $file " existe"
    }
    Get-Item "\\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\*light*.jpg"

}
$i



<#
$filesArqprd = get-item \\arqprd01\arq_neo\arquivos\ANEXO_MONITORA\02BFC0A81E57*.*
write-host $filesArqprd.count arquivos no arqprd01 -BackgroundColor Black -ForegroundColor Red
$filesArqprd |?{$_.lastwritetime -gt "08/31/2014"} | select lastwritetime, name
#>