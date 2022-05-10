function UnimedWorkplace-GetUserId([Parameter(Mandatory = $true)][string]$email)
{ 
$FacebookURL = "https://www.facebook.com/scim/v1/Users?filter=userName%20eq%20%22$email%22"
$token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
$headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
}
$result = $null
$result = Invoke-RestMethod -Method get -Uri $FacebookURL -Headers $headers
if($result.totalResults -ne 0){return $result.Resources.id }else{return $null}
#$result.Resources | Convertto-Json 

}

Function UnimedWorkplace-GetUser([Parameter(Mandatory = $true)][string]$email)
{
$FacebookURL = "https://www.facebook.com/scim/v1/Users?filter=userName%20eq%20%22$email%22"
$token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
$headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
}
$result = $null
$result = Invoke-RestMethod -Method get -Uri $FacebookURL -Headers $headers
if($result.totalResults -ne 0){return $result.Resources}else{return $null}
#$result.Resources | Convertto-Json 

}

function UnimedWorkplace-SetManager([Parameter(Mandatory = $true)]$usuario, [Parameter(Mandatory = $true)][int64]$idmanager)
{
$FacebookURL = "https://www.facebook.com/scim/v1/Users/"+$usuario.id
$token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
$headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
}

$usuario.PSObject.Properties.Remove("id")
$usuario.PSObject.Properties.Remove("externalid")
$usuario.PSObject.Properties.Remove("urn:scim:schemas:extension:facebook:starttermdates:1.0")
$usuario.PSObject.Properties.Remove("urn:scim:schemas:extension:facebook:accountstatusdetails:1.0")
$usuario.schemas = $usuario.schemas | ?{$_ -ne "urn:scim:schemas:extension:facebook:starttermdates:1.0"}
$usuario.schemas = $usuario.schemas | ?{$_ -ne "urn:scim:schemas:extension:facebook:accountstatusdetails:1.0"}

if($usuario.'urn:scim:schemas:extension:enterprise:1.0'.Manager)
{
    $usuario.'urn:scim:schemas:extension:enterprise:1.0'.Manager.managerId = $idmanager
}else{
    $manager = '{"managerId":'+$idmanager+'}'
    $usuario.'urn:scim:schemas:extension:enterprise:1.0' | Add-Member -Name 'manager' -MemberType Noteproperty -Value ($manager | ConvertFrom-Json )
}
#$usuario | Convertto-Json


$result = $null
$result = Invoke-RestMethod -Method put -Uri $FacebookURL -Headers $headers -Body ($usuario | Convertto-Json) -ContentType 'application/json;charset=utf-8' 
if($result){write-host informações atualizadas; return $true}else{write-host erro ao atualizar as informações; return $false}


}

function UnimedWorkplace-DisabelUser([Parameter(Mandatory = $true)][PSCustomObject]$user)
{
$token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
$headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
}


    $user.PSObject.Properties.Remove("urn:scim:schemas:extension:facebook:starttermdates:1.0")
    $user.PSObject.Properties.Remove("urn:scim:schemas:extension:facebook:accountstatusdetails:1.0")
    $user.schemas = $user.schemas | ?{$_ -ne "urn:scim:schemas:extension:facebook:starttermdates:1.0"}
    $user.schemas = $user.schemas | ?{$_ -ne "urn:scim:schemas:extension:facebook:accountstatusdetails:1.0"}
    $user.active = $false
    $json = $user | ConvertTo-Json

    $FacebookURL = "https://www.facebook.com/scim/v1/Users/"+ $user.id
    $result = $null
    $result = Invoke-RestMethod -Method put -Uri $FacebookURL -Headers $headers -Body $json -ContentType 'application/json;charset=utf-8' 
    if($result){write-host $user.name.formatted desativado -BackgroundColor Green -ForegroundColor Black}else{write-host Erro ao desativar $user.name.formatted -BackgroundColor red}


}

function UnimedWorkplace-CreateUser([Parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount]$aduser)
{
  
    $FacebookURL = "https://www.facebook.com/scim/v1/Users/"
    $token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
    $headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
    }

$json = '
{
  "schemas": [
    "urn:scim:schemas:core:1.0",
    "urn:scim:schemas:extension:enterprise:1.0"
  ],
  "userName": "'+$aduser.mail+'",
  "name": {
    "formatted": "'+$aduser.Name+'"
  },
  "title":"'+$aduser.Description+'",
  "active": true,
  "locale": "pt_BR",
  "preferredLanguage": "pt_BR",
  "urn:scim:schemas:extension:enterprise:1.0": {
    "department": "'+$aduser.Department+'"
  }
}
'
#"phoneNumbers":[{"primary":true,"type":"work","value":"+55'+$aduser.OfficePhone+'"}],
#$json | ConvertFrom-Json

$result = $null
$result = Invoke-RestMethod -Method post -Uri $FacebookURL -Headers $headers -Body $json -ContentType 'application/json;charset=utf-8' 
if($result)
{
    write-host Usuário criado; return $result
}else{write-host Erro ao criar o usuário; return $result}

}

function UnimedWorkplace-GetAllUsers()
{
$FacebookURL = "https://www.facebook.com/scim/v1/Users?startIndex=1"
$token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
$headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
}

$wrkUsers = @()

$result = $null
$result = Invoke-RestMethod -Method get -Uri $FacebookURL -Headers $headers 
$index = 1



$result.Resources | %{

$wrkUser = new-object PSObject
  $wrkUser  | add-member -type NoteProperty -Name "id" -Value $_.id
  $wrkUser  | add-member -type NoteProperty -Name "username" -Value $_.username
  $wrkUser  | add-member -type NoteProperty -Name "name" -Value $_.name.formatted
  $wrkUser  | add-member -type NoteProperty -Name "active" -Value $_.active
  $wrkUser  | add-member -type NoteProperty -Name "homepage" -Value ("https://unimedrio.facebook.com/profile.php?id="+$_.id)
  $wrkUser  | add-member -type NoteProperty -Name "manager" -Value $_.'urn:scim:schemas:extension:enterprise:1.0'.manager.managerid
  $wrkUser  | add-member -type NoteProperty -Name "Invited" -Value $_.'urn:scim:schemas:extension:facebook:accountstatusdetails:1.0'.invited
  $wrkUsers += $wrkUser  
}

do
{
    $index = $index +$result.itemsPerPage
    $FacebookURL = "https://www.facebook.com/scim/v1/Users?startIndex=$index"

    $result = Invoke-RestMethod -Method get -Uri $FacebookURL -Headers $headers 
    if($result.itemsPerPage -ne 0){
    $result.Resources | %{
    $wrkUser = new-object PSObject
    $wrkUser  | add-member -type NoteProperty -Name "id" -Value $_.id
    $wrkUser  | add-member -type NoteProperty -Name "username" -Value $_.username
    $wrkUser  | add-member -type NoteProperty -Name "name" -Value $_.name.formatted
    $wrkUser  | add-member -type NoteProperty -Name "active" -Value $_.active
    $wrkUser  | add-member -type NoteProperty -Name "homepage" -Value ("https://unimedrio.facebook.com/profile.php?id="+$_.id)
    $wrkUser  | add-member -type NoteProperty -Name "manager" -Value $_.'urn:scim:schemas:extension:enterprise:1.0'.manager.managerid
    $wrkUser  | add-member -type NoteProperty -Name "Invited" -Value $_.'urn:scim:schemas:extension:facebook:accountstatusdetails:1.0'.invited
    $wrkUsers += $wrkUser  
    }}
    
}while($result.itemsPerPage)
$wrkUsers #| ft -AutoSize

}

function UnimedWorkplace-UpdateUser([Parameter(Mandatory = $true)][Microsoft.ActiveDirectory.Management.ADAccount]$aduser,[Parameter(Mandatory = $true)][PSCustomObject]$userwrk)
{

$FacebookURL = "https://www.facebook.com/scim/v1/Users/"+$userwrk.id
$token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
$headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
}


    $userwrk.PSObject.Properties.Remove("urn:scim:schemas:extension:facebook:starttermdates:1.0")
    $userwrk.PSObject.Properties.Remove("urn:scim:schemas:extension:facebook:accountstatusdetails:1.0")
    $userwrk.schemas = $userwrk.schemas | ?{$_ -ne "urn:scim:schemas:extension:facebook:starttermdates:1.0"}
    $userwrk.schemas = $userwrk.schemas | ?{$_ -ne "urn:scim:schemas:extension:facebook:accountstatusdetails:1.0"}
    
    $userwrk.name.formatted = $aduser.Name
    if(!$userwrk.title)
    {$userwrk  | Add-Member -Name 'title' -MemberType Noteproperty -Value $aduser.Description
    }else{ $userwrk.title = $aduser.Description}

    $schemaEnt10 = $userwrk.'urn:scim:schemas:extension:enterprise:1.0'
    $userwrk.PSObject.Properties.Remove("urn:scim:schemas:extension:enterprise:1.0")
    
    if($userwrk.phoneNumbers -and $aduser.telephoneNumber)
    {
        $arraytel = $userwrk.phoneNumbers
        if(($arraytel[0].value -ne $aduser.telephoneNumber) -and ($arraytel[0].value.Length -lt $aduser.telephoneNumber.Length))
        {
            $arraytel[0].value = $aduser.telephoneNumber
            $userwrk.phoneNumbers = $arraytel
        }
    }else{
        if($aduser.telephoneNumber)
        {
            $arraytel = @([pscustomobject]@{primary="True";type="work";value=$aduser.telephoneNumber})
            $userwrk  | Add-Member -Name 'phoneNumbers' -MemberType Noteproperty -Value $arraytel
        }    
    }    
    
    if($userwrk.addresses -and $aduser.Office)
    {
        $arrayaddress = $userwrk.addresses
        $arrayaddress[0].formatted = $aduser.Office
        $userwrk.addresses = $arrayaddress
    }else{
        if($aduser.Office)
        {
            $arrayaddres = @([pscustomobject]@{type="attributes";formatted=$aduser.Office;primary="True"})
            $userwrk  | Add-Member -Name 'addresses' -MemberType Noteproperty -Value $arrayaddress
        }    
    }  

    if($schemaEnt10)
    {
        $userwrk  | Add-Member -Name 'urn:scim:schemas:extension:enterprise:1.0' -MemberType Noteproperty -Value $schemaEnt10
        if (!$userwrk.'urn:scim:schemas:extension:enterprise:1.0'.department)
        {
            $arraydepartment = @([pscustomobject]@{department="$aduser.department"})
            $userwrk.'urn:scim:schemas:extension:enterprise:1.0' | Add-Member -NotePropertyName "department" -NotePropertyValue $aduser.department
        }else
        {
            $userwrk.'urn:scim:schemas:extension:enterprise:1.0'.department = $aduser.department
        }
    }else
    {
        $urnscimschemasextensionenterprise10 = '{"department":"'+$aduser.department+'"}'
        $userwrk  | Add-Member -Name 'urn:scim:schemas:extension:enterprise:1.0' -MemberType Noteproperty -Value ( $urnscimschemasextensionenterprise10 | ConvertFrom-Json )
    }
      
    $json = $userwrk | ConvertTo-Json


$result = $null
$result = Invoke-RestMethod -Method put -Uri $FacebookURL -Headers $headers -Body $json -ContentType 'application/json;charset=utf-8' 
if($result)
{
    write-host Informações atualizadas; return $result
}else{write-host Erro ao atualizar as informações; return $result}



}

function UnimedWorkplace-GetAllUsersV2()
{
$FacebookURL = "https://www.facebook.com/scim/v1/Users?startIndex=1"
$token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
$headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
}

$wrkUsers = @()

$result = $null
$result = Invoke-RestMethod -Method get -Uri $FacebookURL -Headers $headers 
$index = 1

$result.Resources | %{
 $wrkUsers += $_
}
do
{
    $index = $index +$result.itemsPerPage
    $FacebookURL = "https://www.facebook.com/scim/v1/Users?startIndex=$index"

    $result = Invoke-RestMethod -Method get -Uri $FacebookURL -Headers $headers 
    if($result.itemsPerPage -ne 0){
    $result.Resources | %{$wrkUsers += $_}
    }
    
}while($result.itemsPerPage)
$wrkUsers #| ft -AutoSize

}