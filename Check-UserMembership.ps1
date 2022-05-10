function get-GroupMembership($DNName,$cGroup){
	
	$strFilter = "(&(objectCategory=User)(samAccountName=$strName))"

	$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
	$objSearcher.Filter = $strFilter

	$objPath = $objSearcher.FindOne()
	$objUser = $objPath.GetDirectoryEntry()
	$DN = $objUser.distinguishedName
		
	$strGrpFilter = "(&(objectCategory=group)(name=$cGroup))"
	$objGrpSearcher = New-Object System.DirectoryServices.DirectorySearcher
	$objGrpSearcher.Filter = $strGrpFilter
	
	$objGrpPath = $objGrpSearcher.FindOne()

	
	If (!($objGrpPath -eq $Null)){
		
		$objGrp = $objGrpPath.GetDirectoryEntry()

		
		$grpDN = $objGrp.distinguishedName
		$ADVal = [ADSI]"LDAP://$DN"
	
		if ($ADVal.memberOf.Value -eq $grpDN){
			$returnVal = 1
			return $returnVal = 1
		}else{
			$returnVal = 0
			return $returnVal = 0
	
		}
	
	}else{
			$returnVal = 0
			return $returnVal = 0
	
	}
		
}