Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin
$Mailboxes = Get-Mailbox -ResultSize Unlimited

$addresses = @()
ForEach ($mbx in $Mailboxes) {
    Foreach ($address in $mbx.EmailAddresses) {
        if ($address.ToString().ToLower().StartsWith("smtp:carlos@")) {
            $obj = "" | Select-Object Alias,EmailAddress
            $obj.Alias = $mbx.Alias
            $obj.EmailAddress = $address.ToString().SubString(5)
            $addresses += $obj
        }
    }
}
$addresses
