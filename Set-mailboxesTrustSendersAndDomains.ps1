Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.snapin

$domains = @("w3net.com.br","unimed.com.br")

$mbxs = get-mailbox -ResultSize unlimited
foreach($mbx in $mbxs)
{
    $lista = ($mbx | Get-MailboxJunkEmailConfiguration).TrustedSendersAndDomains
    
    $domains | %{
        if($lista -notcontains $_.tostring())
        {
            $lista += $_
            
        }
    }

    $mbx  | Set-MailboxJunkEmailConfiguration -TrustedSendersAndDomains $lista
    $lista = $null
}