New-VM -VMFilePath  '[DS-APP01] UNIRJAD01/UNIRJAD01.vmx'  -VMHost $ESXHost -Location $VMFolder -RunAsync
New-VM -VMFilePath "[DS-APP02] UNIRJAD02/UNIRJAD02.vmx" -VMHost $ESXHost -Location $VMFolder -RunAsync

Get-VM 	UNIRJAD01	| Get-NetworkAdapter -Name 	'Network adapter 1'	| Set-NetworkAdapter -NetworkName 	VLAN_1113_PROD_0	-StartConnected	 $true	 -confirm:$false
Get-VM 	UNIRJAD01	| Get-NetworkAdapter -Name 	'Network adapter 2'	| Set-NetworkAdapter -NetworkName 	VLAN_1113_PROD_0	-StartConnected	 $false	 -confirm:$false
Get-VM 	UNIRJAD01	| Get-NetworkAdapter -Name 	'Network adapter 3'	| Set-NetworkAdapter -NetworkName 	VLAN_1113_PROD_0	-StartConnected	 $false	 -confirm:$false

Get-VM 	UNIRJAD02	| Get-NetworkAdapter -Name 	'Network adapter 2'	| Set-NetworkAdapter -NetworkName 	VLAN_1113_PROD_0    -StartConnected	 $false	 -confirm:$false
Get-VM 	UNIRJAD02	| Get-NetworkAdapter -Name 	'Network adapter 4'	| Set-NetworkAdapter -NetworkName 	VLAN_1113_PROD_0	-StartConnected	 $true	 -confirm:$false
Get-VM 	UNIRJAD02	| Get-NetworkAdapter -Name 	'Network adapter 3'	| Set-NetworkAdapter -NetworkName 	VLAN_1113_PROD_0	-StartConnected	 $false	 -confirm:$false

Start-VM -VM UNIRJAD01
Start-VM -VM UNIRJAD02


