
$Computers = Get-Content C:\temp\serversgoogle.com

 $Output = @()

Foreach ($Computer in $Computers)
{
    $server = New-Object PSObject -Property @{   
    name = $null
    socket = $null
    }
    $cs = Get-WmiObject -class Win32_ComputerSystem -ComputerName $Computer
    $server.name = $Computer
    $server.socket = $cs.NumberOfProcessors
    $server
    $Output += $server 
}
$Output | ft name, socket