$servidor = Read-Host "Nome do servidor"
$processname = Read-Host "Nome do processo"
$processes = Get-WmiObject -Class Win32_Process -ComputerName $servidor -Filter "name like '$processname%'"
if ($processes)
{
    Write-Host "Processos encontrados" -ForegroundColor Green -BackgroundColor Red
    foreach ($process in $processes)
    {
        $processid = $process.handle
        $processName = $process.processName
        write-host "Nome: $processname `($processid`)"
    }

}else{
        write-host "Nenhum processo encontrado!" -ForegroundColor Red
        break
}

write-host "`n Digite OK para matar todos os processos encontrados" -ForegroundColor Yellow
$input = Read-Host "Digite a opção"
switch ($input)
{
    OK {
    foreach ($process in $processes)
    {
        $returnval = $process.terminate()
        $processid = $process.handle
 
        if($returnval.returnvalue -eq 0) 
        {
            write-host "Processo $process `($processid`) terminado com sucesso" -ForegroundColor Yellow
        } else
        {
            write-host "Processo $process `($processid`) não foi finalizado com sucesso e/ou teve problemas" -ForegroundColor Red
        }
    }    
    break
    }
    default {"opcao errada" ; break}
}