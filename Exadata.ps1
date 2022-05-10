###################### NEO ############################################
$srvneo = @("neobarprd01","neobarprd02","neobarprd03","neopdoprd01","neopdoprd02","neoextprd01","neoextprd02","neorbmprd01","nfsewsprd01")
foreach($srv in $srvneo)
{
    $svcs = Get-Service -ComputerName $srv -Name w3svc
    foreach($svc in $svcs)
    {
        $svc.Stop()
    }
    $Processes = Get-WmiObject -Class Win32_Process -ComputerName $srv | ?{$_.Name -like "dllhost*"}
    foreach ($process in $processes)
    {
        $returnval = $process.terminate()
        $processid = $process.handle
        if($returnval.returnvalue -eq 0)
        {
            write-host "O processo $ProcessName `($processid`) terminado com sucesso" -ForegroundColor Green
        }else
        {
            write-host "O processo $ProcessName `($processid`) não foi finalizado com sucesso" -ForegroundColor Red
        }
    }


}

foreach($srv in $srvneo)
{
    $svcs = Get-Service -ComputerName $srv -Name w3svc
    foreach($svc in $svcs)
    {
        $svc | select MachineName,status,name,displayname
    }

}

foreach($srv in $srvneo)
{
    $svcs = Get-Service -ComputerName $srv -Name w3svc
    foreach($svc in $svcs)
    {
        $svc.Start()
    }
}

###################### POLN ############################################
$srvpoln = @("polnappprd04","polnappprd05","polnwsprd01","polnwsprd02")
foreach($srv in $srvpoln)
{
    $svcs = Get-Service -ComputerName $srv -Name w3svc
    foreach($svc in $svcs)
    {
        $svc.Stop()
    }
}
foreach($srv in $srvpoln)
{
    $svcs = Get-Service -ComputerName $srv -Name w3svc
    foreach($svc in $svcs)
    {
        $svc | select MachineName,status,name,displayname
    }
}

###################### middleware ############################################
$srvmw = @("mwprd01")
foreach($srv in $srvmw)
{
    $svcs = Get-Service -ComputerName $srv -Name neo*
    foreach($svc in $svcs)
    {
        $svc.Start()
    }
}
foreach($srv in $srvmw)
{
    $svcs = Get-Service -ComputerName $srv -Name neo*
    foreach($svc in $svcs)
    {
        $svc | select MachineName,status,name,displayname
    }
}

###################### NFSe ############################################
$srvnfse = @("nfseprd01")
foreach($srv in $srvnfse)
{
    $svcs = Get-Service -ComputerName $srv -Name nfse*
    foreach($svc in $svcs)
    {
        $svc.Start()
    }
}
foreach($srv in $srvnfse)
{
    $svcs = Get-Service -ComputerName $srv -Name nfse*
    foreach($svc in $svcs)
    {
        $svc | select MachineName,status,name,displayname
    }
}

###################### POSDEV ############################################
$srvposdev = @("posdev01")
foreach($srv in $srvposdev )
{
    $svcs = Get-Service -ComputerName $srv -Name clientd*,scs4*
    foreach($svc in $svcs)
    {
        $svc.Start()
    }
}
foreach($srv in $srvposdev )
{
    $svcs = Get-Service -ComputerName $srv -Name clientd*,scs4*
    foreach($svc in $svcs)
    {
        $svc | select MachineName,status,name,displayname
    }
}