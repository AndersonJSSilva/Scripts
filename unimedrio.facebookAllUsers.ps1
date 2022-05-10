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
  $wrkUsers += $wrkUser  
}

while($result.itemsPerPage -eq 100)
{
    $index = $index +100
    $FacebookURL = "https://www.facebook.com/scim/v1/Users?startIndex=$index"

    $result = Invoke-RestMethod -Method get -Uri $FacebookURL -Headers $headers 
    $result.Resources | %{
    $wrkUser = new-object PSObject
    $wrkUser  | add-member -type NoteProperty -Name "id" -Value $_.id
    $wrkUser  | add-member -type NoteProperty -Name "username" -Value $_.username
    $wrkUser  | add-member -type NoteProperty -Name "name" -Value $_.name.formatted
    $wrkUser  | add-member -type NoteProperty -Name "active" -Value $_.active
    $wrkUser  | add-member -type NoteProperty -Name "homepage" -Value ("https://unimedrio.facebook.com/profile.php?id="+$_.id)
    $wrkUser  | add-member -type NoteProperty -Name "manager" -Value $_.'urn:scim:schemas:extension:enterprise:1.0'.manager.managerid
    $wrkUsers += $wrkUser  
    }
}

$wrkUsers | ft -AutoSize

}
