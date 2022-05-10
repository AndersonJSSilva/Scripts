
$Computers = Get-Content C:\temp\serversgoogle.com

 $Output = @()

Foreach ($Computer in $Computers)
{
    $server = New-Object PSObject -Property @{   
    name = $null
    used = $null
    size = $null
    }

    $used = 0
    $size = 0
    
     Get-WmiObject Win32_Volume -Filter "DriveType='3'" -ComputerName $Computer | ?{$_.name -notlike "*volume*"} | ForEach {
                    
                    $server.name = $Computer
                    $used += ([Math]::Round($_.Capacity /1GB,2)) - ([Math]::Round($_.FreeSpace /1GB,2))
                    $size += ([Math]::Round($_.Capacity /1GB,2))
                    
                    New-Object PSObject -Property @{
                                                         
                    Name = $_.Name
                    Label = $_.Label
                    Computer = $Computer
                    FreeSpace_GB = ([Math]::Round($_.FreeSpace /1GB,2))
                    TotalSize_GB = ([Math]::Round($_.Capacity /1GB,2))
                    UsedSpace_GB = ([Math]::Round($_.Capacity /1GB,2)) - ([Math]::Round($_.FreeSpace /1GB,2))
                }
            }
            $server.used = $used
            $server.size = $size

       $Output += $server 
}
$Output | ft name, used, size