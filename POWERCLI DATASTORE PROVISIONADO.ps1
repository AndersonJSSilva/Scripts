Get-Datastore comp*,vnx* | Select Name,CapacityGB,
@{N="UsedGB"; E={[math]::round(($_.CapacityGB - $_.FreeSpaceGB)) }},
@{N="FreeSpaceGB"; E={[math]::round(($_.FreeSpaceGB)) }},
@{N="ProvisionedGB"; E={[math]::round(($_.ExtensionData.Summary.Capacity - $_.ExtensionData.Summary.FreeSpace + $_.ExtensionData.Summary.Uncommitted)/1GB) }}| 
Sort-Object -Property Name | FT Name,CapacityGB,UsedGB,FreeSpaceGB,ProvisionedGB