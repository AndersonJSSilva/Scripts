#####################CONEXÕES CORRENTES####################
$computers = @("neoappprd01","neoappprd02","neoappprd03","neoappprd04","neoappprd05","neoappprd06","neoapppdo01","neoapppdo02")
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




