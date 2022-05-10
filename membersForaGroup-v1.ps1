$Searcher = New-Object DirectoryServices.DirectorySearcher -Property @{
    Filter = "(memberof=CN=_Infra-TI_ativas,CN=Users,DC=unimedrj,DC=root)"
    PageSize = 1000
}

$users = $Searcher.FindAll()

foreach($user in $users){
        $user

}
<#
$users | ForEach-Object{
    New-Object -TypeName PSCustomObject -Property @{
        samaccountname = $_.Properties.samaccountname -join ''
        pwdlastset = [datetime]::FromFileTime([int64]($_.Properties.pwdlastset -join ''))
        enabled = -not [boolean]([int64]($_.properties.useraccountcontrol -join '') -band 2)
    }
   
}#>

