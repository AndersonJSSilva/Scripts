Get-ADComputer -Identity "UNIBARNT025035" -Properties *
Get-ADUser -filter {description -like "siebel*"} -Properties * | select mail, samaccountname, name

$users = Get-Content -Path C:\temp\mstr.txt
$users.Length
foreach($user in $users)
{
   try{
        $usrtmp = Get-ADUser -identity $user -properties * -ErrorAction SilentlyContinue
        if( $usrtmp.Enabled)
        {  Write-Host $usrtmp.Name $usrtmp.SamAccountName $usrtmp.Enabled -ForegroundColor black }
        else
        {  Write-Host $usrtmp.Name $usrtmp.SamAccountName $usrtmp.Enabled -ForegroundColor Red   }
   }
   catch{write-host $user Não encontrado -foregroundColor Yellow}
}

get-adgroup -Filter {samaccountname -like "*"} -properties * | select name, groupcategory, description,info | Export-Csv -Path c:\temp\adgroups.csv -Encoding Unicode

(Get-ADUser -filter {name -like "*Bruno Gonçalves*"}  -properties *).memberOf
Get-ADGroupMember -Identity "_admdoc" | select samaccountname,name

$gourps = Get-ADGroup -filter {name -like "*"} -Properties *
foreach($gpr in $groups)
{
    write-host $gpr.name -foregroundColor Yellow
    #############  membros de um grupo  #################################
    $users = (Get-ADGroup -filter {samaccountname -like $gpr.samaccountname} -Properties * ).members
    foreach($usr in $users)
    {
        $usr = ($usr = ($usr -replace "CN=","").Split(","))[0]
        $tmp = Get-ADUser -filter {name -like $usr} -Properties * | select samaccountname,name, description
        Write-Host "`t"$tmp.samaccountname";"$tmp.name";"$tmp.description

    }
    #####################################################################
}