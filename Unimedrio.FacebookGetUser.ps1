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
