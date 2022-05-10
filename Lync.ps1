$data = "20140411"
$data = "(WhenCreated>=" + $data + "000000.0Z)"
$adusers = Get-CsAdUser -LDAPFilter "$data" | Where-Object {$_.WindowsEmailAddress}
$adusers | Get-CsUser | sort samaccountname | format-table -property name, samaccountname