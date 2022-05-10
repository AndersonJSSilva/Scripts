$entrada = Get-Content C:\temp\gruposxshare.txt
$entrada = Get-Content C:\temp\ARQPRD02.txt
$entrada = Get-Content C:\temp\arqprd03.txt
$entrada = Get-Content C:\temp\tempgroup.txt

$server = "arqprd03"
foreach($ent in $entrada)
{

    #Write-Host $ent -ForegroundColor Yellow
    $share = ($ent -split ";")[0]
    $grupo = ($ent -split ";")[1]
    $resp =  ($ent -split ";")[2]+"*"
    $respad =  Get-ADUser -Filter {displayname -like $resp} -Properties *
    $info = "Resp. "+ $respad.displayname
    $managerdn = $respad.distinguishedname
    if(!$respad)
    {
        $resp =  ($ent -split ";")[2]+"*"
        $respad = Get-ADUser -Filter {name -like $resp} -Server adsrv33.uremh.local -Properties *
        $info = "Resp. "+ $respad.displayname
        $managerdn = $respad.distinguishedname
    }
    #Write-Host \\$server\$share - $grupo - $info - $managerdn
    #Set-ADGroup -Identity $grupo -Description "\\$server\$share" -replace @{info="$info"}
    if($managerdn)
    {Set-ADGroup -ManagedBy $managerdn -Identity $grupo}
    #else
    #{write-host $ent - sem manager}
    
    $info = $null
    $respad = $null
    $managerdn = $null
   
}





#realiza backup
$bkp = @()
foreach($ent in $entrada)
{

    $grupo = ($ent -split ";")[1]
    $tmp = Get-ADGroup -Filter {name -eq $grupo} -Properties * | select name, description, info, @{Label="managedby";Expression={($_.managedby -split ",")[0] -replace "CN=",""}}
    $bkp += $tmp
}
$bkp | Export-Csv c:\temp\RelArqprd03.csv -Encoding Unicode



#verifica
foreach($ent in $entrada)
{
    $grupo = (($ent -split ";")[1]).Trim()
    $tmp = $null
    $tmp=Get-ADGroup -Filter {samaccountname -eq $grupo} -Properties * | select name, description, info, @{Label="managedby";Expression={($_.managedby -split ",")[0] -replace "CN=",""}}
    if(!$tmp)
    {
    Write-Host $grupo -ForegroundColor Red
    }else{
    $tmp
    }
}


