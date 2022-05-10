function UnimedWorkplace-SetManager([Parameter(Mandatory = $true)][string]$idusuario, [Parameter(Mandatory = $true)][string]$idmanager)
{

$token = "DQVJzSFlSN05ORE9HN2VUWUlLaXBVem52NWlTdUI3RzVMajlpUzRaNlVUNTdyZA1JDZATZAVenZABZAGJjeWlLYjB6TV9WT1BMVXNlcGNwemhoblgzTzVJQUtlc1MyOWlITkxpMGhmWi1HUG40bEphRGM4UzlVWEg5cVdacmFqTlNPM3cyMkR1Nk5OVmhyUG1RT2N5TjJua0JfVHN0bHlySHZAkQS1iMlozdTJCb3QzN3doekc0SXowZA19EbTVOLTg3SDVvMTMyU0szM1VmTXBZAa0c0UAZDZD"
$headers = @{
    "Host" = "www.facebook.com"
    "Authorization" = "Bearer $token"
}

}
<#
$json | Convertfrom-Json 

#>

$json = '{
    "schemas":  [
                    "urn:scim:schemas:core:1.0",
                    "urn:scim:schemas:extension:enterprise:1.0"
                ],
    "userName":  "carlos.david@unimedrio.com.br",
    "name":  {
                 "formatted":  "Carlos David"
             },
    "active":  true,
    "urn:scim:schemas:extension:enterprise:1.0":  {
                                                      "department":  "Infraestrutura de TI",
                                                      "manager":  {
                                                                      "managerId":  100018995109674
                                                                  }
                                                  }
}'

