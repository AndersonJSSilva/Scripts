$AVs = Get-Content "C:\temp\Lastcom.txt"
$avs.Count
foreach ($AV in $AVs) 
{

try{ Test-Connection -ComputerName $AV -Count 1 -ErrorAction Stop} catch {write-host $AV OffLine}

}


$computers = Get-Content "C:\Users\M50610\Desktop\computeroff.txt"
$computers.Count
foreach ($computer in $computers)
{

Remove-ADComputer -Identity $computer.Trim() -Confirm:$false

}

Remove-ADComputer -Identity UNIBAR01034004 -Confirm:$false

$dats = Get-Content "c:\temp\DATANTIGA.txt"
$data = (Get-Date).AddDays(-10)
foreach ($dat in $dats)
{

try {Get-ADComputer -identity $dat -properties * | ?{$_.LastLogonDate -lt $data } | select samaccountname,LastLogonDate}catch{write-host $dat -ForegroundColor red}

}


