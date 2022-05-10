$servers = @("sieurehdev02","sieurehhmg02","sieurehprd02","siecoopdev02","siecoophmg02","siecoopprd02","siecoopprd01","siecoophmg01","siecoopdev01","sieurehprd01","sieurehdev01","sieurehhmg01")
foreach($srv in $servers)
{

    $saida = Get-WmiObject win32_OperatingSystem -ComputerName $srv 
    write-host $saida.PSComputerName -ForegroundColor Yellow
    write-host "Memória total: " ("{0:N0}" -f (($saida.totalvisiblememorysize/1024)/1024))"GB"
    write-host "Memória livre: " ("{0:N0}" -f (($saida.freephysicalmemory/1024)/1024))"GB"
    write-host "Memória usada: " ("{0:N0}" -f (100-(((($saida.freephysicalmemory/1024)/1024))*100)/((($saida.totalvisiblememorysize/1024)/1024))))"%"
    write-host "Memoria Virtual Total: " ("{0:N0}" -f (($saida.TotalVirtualMemorySize/1024)/1024))"GB"
    write-host "Memória Virtual Livre: " ("{0:N0}" -f (($saida.FreeVirtualMemory/1024)/1024))"%"
    write-host""

}








