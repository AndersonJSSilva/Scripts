## Return members of given AD group
 
function  Get-GroupMembers {
 
    param ([string]$group)
 
    if (-not ($group)) { return $false }
   
 
    $searcher=new-object directoryservices.directorysearcher   
    $filter="(&(objectClass=group)(cn=${group}))"
    $searcher.PageSize=1000
    $searcher.Filter=$filter
    $result=$searcher.FindOne()
 
    if ($result) {
        $members = $result.properties.item("member")
 
        ## Either group is empty or has 1500+ members
        if($members.count -eq 0) {                       
 
            $retrievedAllMembers=$false          
            $rangeBottom =0
            $rangeTop= 0
 
            while (! $retrievedAllMembers) {
 
                $rangeTop=$rangeBottom + 1499               
 
               ##this is how it would show up in AD
                $memberRange="member;range=$rangeBottom-$rangeTop"  
 
                $searcher.PropertiesToLoad.Clear()
                [void]$searcher.PropertiesToLoad.Add("$memberRange")
 
                $rangeBottom+=1500
 
                try {
                    ## should cause and exception if the $memberRange is not valid
                    $result = $searcher.FindOne() 
                    $rangedProperty = $result.Properties.PropertyNames -like "member;range=*"
                    $members +=$result.Properties.item($rangedProperty)          
                    
                     # UPDATE - 2013-03-24 check for empty group
                      if ($members.count -eq 0) { $retrievedAllMembers=$true }
                }
 
                catch {
 
                    $retrievedAllMembers=$true   ## we received all members
                }
 
            }
 
        }
 
        $searcher.Dispose()
        return $members
 
    }
    return $false  
}

$grupo = "_Coordenadores  Assessores de Área e Gerentes de Unidades"

$users = Get-GroupMembers "$grupo"
Write-Host "`n"
foreach ($user in $users){

    $user
    
}
