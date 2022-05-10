#$ComputerName = "arqprd02"
$ComputerName = Get-Content C:\temp\scanshare.txt

$OutputArray = @()

	foreach($Computer in $ComputerName) {
		$OutputObj = New-Object –TypeName PSObject –Prop (@{
				'ComputerName'=$Computer.ToUpper();
				'ShareName' = $null;
                'Status'=$null;
                'EveryOneAccess'=$false
			})
	
	
		Write-host "Working on $Computer"
		if(!(Test-Connection -Computer $Computer -Count 1 -Ea 0)) {
			Write-host "$Computer is offline"
			$OutputObj = New-Object –TypeName PSObject –Prop (@{
				'ComputerName'=$Computer.ToUpper();
				'ShareName' = $null;
                'Status'="Not_Found";
                'EveryOneAccess'=$null
			})
			$OutputObj
			$OutputArray +=$OutputObj
			
			Continue
		}
		
		try {
			$Shares = Get-WmiObject -Class Win32_LogicalShareSecuritySetting `
									-ComputerName $Computer `
									-ErrorAction Stop
			$Status = "Successful"						
		} catch {
			Write-host "Failed to Query WMI class. More details: $_"
			$OutputObj = New-Object –TypeName PSObject –Prop (@{
				'ComputerName'=$Computer.ToUpper();
				'ShareName' = $null;
                'Status'="WMIFailed";
                'EveryOneAccess'=$null
			})
			
			$OutputObj
			$OutputArray +=$OutputObj
			
			Continue
		}
		
		foreach($Share in $Shares) {
			$OutputObj = New-Object –TypeName PSObject –Prop (@{
				'ComputerName'=$Computer.ToUpper();
				'ShareName' = $Share.Name;
                'Status'=$Status;
                'EveryOneAccess'=$false
			})
			#$OutputObj.ShareName = $Share.Name
			$Permissions = $Share.GetSecurityDescriptor()
			foreach($perm in $Permissions.Descriptor.DACL) {
				if($Perm.Trustee.Name -eq "EveryOne" )
                {
					$OutputObj.EveryOneAccess = $true

				} 
			}
        if($OutputObj.EveryOneAccess -eq $true){
		    $OutputObj
		    $OutputArray +=$OutputObj
            
        }
		}
	}
	
#$OutputArray | ft computerName,ShareName, EveryOneAccess -AutoSize
#-and $Perm.AccessMask -eq "2032127" -and $Perm.AceType -eq 0

$OutputArray |select computerName,ShareName, EveryOneAccess | export-csv c:\temp\shares.csv -Encoding Unicode