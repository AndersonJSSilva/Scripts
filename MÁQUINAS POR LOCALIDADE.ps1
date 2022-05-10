$computers = Get-Content -Path C:\micros.txt
$computerBarra = @()
$computerCentro = @()
$computerBenfica = @()
$computerOffline = @()      


#$computer = "unipdo09057081"
foreach ($computer in $computers) 
{
    if (test-Connection -count 1 -Cn $computer -quiet)
    {

       $ip = [System.Net.Dns]::GetHostAddresses($computer)
        
        if($ip[0].IPAddressToString -like '10.250*')
        {
                   
            $computerCentro += $computer

        }
        if($ip[0].IPAddressToString -like '10.110*')
        {
            
            $computerBarra += $computer
        }
        if($ip[0].IPAddressToString -like '10.100*')
        {
            
            $computerBarra += $computer
        }
        if($ip[0].IPAddressToString -like '10.101*')
        {
             
            $computerBenfica += $computer
        }
        if($ip[0].IPAddressToString -like '10.128*')
        {
            
            $computerBarra += $computer
        }
        if($ip[0].IPAddressToString -like '10.200*')
        {
            
            $computerBarra += $computer
        }
        if($ip[0].IPAddressToString -like '10.104*')
        {
            
            $computerBarra += $computer
        }
        if($ip[0].IPAddressToString -like '10.105*')
        {
            
            $computerBarra += $computer
        }
       
    }
     else {       
     $computerOffline += $computer
    } 
}
