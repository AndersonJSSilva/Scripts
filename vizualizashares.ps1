
$strcomputers = Get-Content c:\servers.txt
foreach ($strcomputer in $strcomputers)
{
        write-host $strcomputer
        Get-WmiObject -computer $strcomputer Win32_share | FT path, name -autosize
      
}
