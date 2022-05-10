$patern = @("<statussolicitacao>2")
$result = Get-ChildItem -recurse -Path "\\arqprd01\arq_neo\arquivos\POLN_WS\WS\LogsWS01-Tiss2\2016\8\30\wstiss_*.log" -Include *.log| Select-String -pattern $patern  #| select @{l="File";e={($_.path).Substring(110)}},linenumber,pattern
$result += Get-ChildItem -recurse -Path "\\arqprd01\arq_neo\arquivos\POLN_WS\WS\LogsWS02-Tiss2\2016\8\30\wstiss_*.log" -Include *.log| Select-String -pattern $patern  #| select @{l="File";e={($_.path).Substring(110)}},linenumber,pattern

$result.count

foreach($rst in $result)
{
   ($rst.Filename -split "_")[5].Substring(0,2) +":"+($rst.Filename -split "_")[5].Substring(2,2)+":"+($rst.Filename -split "_")[5].Substring(4,2)+"."+($rst.Filename -split "_")[5].Substring(6,3)+";"+$rst.Filename
}

foreach($rst in $result)
{
   ($rst.Filename -split "_")[5]
}



