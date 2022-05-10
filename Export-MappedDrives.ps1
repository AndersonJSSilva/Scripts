function Get-NetworkDrives{            
    Start-Sleep 60
    return gwmi win32_logicaldisk -computer localhost -filter "drivetype=4" | select DeviceID,ProviderName   
}   

Get-NetworkDrives | Export-Csv "\\dcbar01\scriptlog$\Powershell\$env:username.csv" -Encoding Unicode -Append


Import-Csv "c:\temp\m41718.csv" -Encoding Unicode



Get-ADUser -Filter {whenCreated -gt $datainicio } -Properties * | select name 
