[array]$servers = (Read-Host “Servidores (separatdos por virgula)”).split(“,”) | %{$_.trim()} 
$processname = Read-Host "Nome do processo"

foreach ($server in $servers ){
$processes = Get-WmiObject -Class Win32_Process -ComputerName $server -Filter "name like '$processname%'"
if ($processes)
{
    Write-Host "`n" $server" - Processos encontrados" -ForegroundColor Green -BackgroundColor red 
    foreach ($process in $processes)
    {
        $processid = $process.handle
        $processName = $process.processName
        $processPath = $process.Path
        write-host "`t Nome: $processname `($processid`) `t"$processPath
    }

}else{
        write-host "`n Nenhum processo encontrado!" -ForegroundColor green -BackgroundColor red 
        break
}
}