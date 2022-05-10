$Services = @()
$computers = Get-Content C:\temp\onda6.txt
$computers 
foreach($srv in $computers)
{
    Write-Host $srv -ForegroundColor Green
    $Services+=get-wmiobject win32_service -ComputerName $srv # | where-object {$_.StartName -like "*administra*"}  
}

$Services | where-object {$_.startName -like "*administra*"} | select PSComputerName, Displayname, Startname


