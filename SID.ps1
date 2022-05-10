$objSID = new-Object System.Security.Principal.SecurityIdentifier ("9b7367e5-6bf8-4d16-ac99-a1e19ff3413d") 
$objUser = $objSID.Translate( [System.Security.Principal.NTAccount]) 
$objUser.Value


$objUser = New-Object System.Security.Principal.NTAccount("unimedrj", "m50610") 
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier]) 
$strSID.Value

Get-ADUser -Filter 'sid -eq "9b7367e5-6bf8-4d16-ac99-a1e19ff3413d"' -Properties *| select displayname, samaccountname

Get-ADUser -identity m50610 -Properties *| select displayname, objectsid