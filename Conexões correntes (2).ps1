#####################CONEXÕES CORRENTES####################
$computers = @("neopdoprd01","neobarprd03","neobarprd01","neobarprd02","neoextprd01","neoextprd02")
$result = $null
foreach ($computer in $computers)

{
    try {
    $connections = Get-Counter -Counter 'web service(topsaude)\current connections' -ComputerName $computer
    foreach($connection in $connections)
    {
        if($connection)
        { 

        Write-Host "########################"  $computer   "########################" -ForegroundColor Red
        Write-Host $connection.Readings -ForegroundColor Yellow
           #$result += "########################" + $computer  + "########################"
           #$result +="`n"+  $connection.Readings +"`n"
        }
    }
    }catch{}

    

}