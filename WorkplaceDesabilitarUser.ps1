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
    if($result){write-host $user.name.formatted desativado -BackgroundColor Green -ForegroundColor Black; return $true}else{write-host Erro ao desativar $user.name.formatted -BackgroundColor red;return $false}


}

$user = UnimedWorkplace-GetUser -email "George.Bush@unimedrio.com.br"
if($user)
{
    if($user.active -eq $false)
    {
        Write-Host O usuário $user.name.formatted já está desabilitado no Wokplace
        
    }
    else
    {
        if(UnimedWorkplace-DisabelUser -user $user)
        {
            Write-Host O usuário $user.name.formatted foi desabilitado no Wokplace
        }else
        {
            Write-Host Erro ao desabilitar o usuário $user.name.formatted no Workplace
        }
    }
}else
{
    Write-Host Usuário não encontrado no Workplace
}