$computers = Get-Content C:\temp\computers.txt
foreach($pc in $computers)
{

    $pc
    gwmi Win32_QuickFixEngineering -ComputerName $pc | ? {$_.InstalledOn} | where { (Get-date($_.Installedon)) -gt (get-date 01/01/2012) }

}
