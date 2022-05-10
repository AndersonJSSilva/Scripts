#################################### Energia Windows 7###############################################################################

$computers = @("UNICOOP30409","pcjean-pc","UNICOOP30382","unicoop30427","unicoop30410") 
#$computers = Get-Content -Path C:\PsTools\Desktops\Desktops.txt
$computerOnline7 = @()
$computerOnlineXP = @()
$computerOffline = @()


foreach ($computer in $computers)
{
$user=""
$usertmp = @(Get-WmiObject -ComputerName $computer -Namespace root\cimv2 -Class Win32_ComputerSystem)[0].UserName
$usertmp = $usertmp -replace "UNIMEDRJ\\",""
$user = Get-adUser -identity $usertmp -Properties * | select name, DisplayName, samaccountname



    if (test-Connection -count 1 -Cn $computer -quiet)
    {
        $OS = Get-WmiObject -Computer $computer -Class Win32_OperatingSystem
        if($OS.caption -like '*Windows 7*')
        {

            $computerOnline7 += $computer + " : " + $user.DisplayName + " : " + $user.samaccountname

        }
        $OS = Get-WmiObject -Computer $computer -Class Win32_OperatingSystem
        if($OS.caption -like '*Windows xp*')
        {
            
            $computerOnlineXP += $computer + " : " + $user.DisplayName + " : " + $user.samaccountname
        }
    }
     else {
     $computerOffline += $computer + $computer + " : " + $user.DisplayName + " : " + $user.samaccountname
    }
}


$computerOnline7 | Out-File C:\computadores\Windows7.txt
$computerOnlineXP  | Out-File C:\computadores\WindowsXP.txt