$servers = Get-Content C:\PsTools\maquinas.txt
 ForEach ($server in $servers) {
    $time = $null
    $time = ([WMI]'').ConvertToDateTime((gwmi win32_operatingsystem -computername $server).LocalDateTime)
    $server + '  ' + $time
}