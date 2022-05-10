$objUser = new-Object System.Security.Principal.NTAccount("unimedrj", "sql_servico")
$strSID = $objUser.Translate([System.Security.Principal.SecurityIdentifier])
$strSID.Value


$objUser = new-Object System.Security.Principal.SecurityIdentifier("S-1-5-21-856173678-1217879051-1509252994-16667")
$strSID = $objUser.Translate([System.Security.Principal.NTAccount])
$strSID.Value

