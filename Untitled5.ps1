$alluser= UnimedWorkplace-GetAllUsers | ?{($_.active -eq $true) -and ($_.username -like "*@unimedrio.com.br")}
$alluser.Count

$filter = $alluser | ?{$_.manager -eq $null} 

$filter = $filter  | ?{$_.username -notlike "Romeu*"} 
$filter.Count
$managers = @()
foreach($fb in $filter)
{
    $tmp = $fb.username
    $manager = Get-ADUser -Filter {mail -eq $tmp} -Properties * | select mail, manager
    $idmanager = (($manager.manager -split ",")[0] -replace "CN=","") -replace " ","."
    $idmanager = $idmanager + "@unimedrio.com.br"
    $id = UnimedWorkplace-GetUserId -email $idmanager
    if($id)
    {
        #UnimedWorkplace-SetManager -usuario (UnimedWorkplace-GetUser -email $manager.mail) -idmanager $id

    }
    $idmanager = $id = $null

}
$mng = $managers | Group-Object manager | select name

foreach($m in $mng)
{
    $tmp = $m.name
    $tmp
    if ($tmp){
    $usr = Get-ADUser -Filter {distinguishedname -eq $tmp} -Properties * 
    if (UnimedWorkplace-GetUser -email $usr.mail)
    {
        #write-host $usr.Name usuário está no FB -ForegroundColor Green
        
    }else{

        write-host $usr.Name usuário não está no FB -ForegroundColor red
        #Add-ADGroupMember -Identity workplaceusers -Members $usr

    }

    }

}

$backup = Get-ADGroupMember -Identity workplaceusers
(Get-ADGroupMember -Identity workplaceusers).count