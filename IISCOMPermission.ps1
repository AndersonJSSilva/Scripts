$comAdmin = New-Object -comobject COMAdmin.COMAdminCatalog
$servers = @("neotst2012std")

foreach($server in $servers)
{
$comAdmin.Connect($server)
$applications = $comAdmin.GetCollection("Applications") 
$applications.Populate() 

foreach ($application in $applications)
{    
    if ($application.Name -like "TOPSAUDE*")
    {
        $application.name
        $components = $applications.GetCollection("Components",$application.key)
        $components.Populate()

        foreach ($component in $components)
        {
        $component.name        
        $component.Value("IISIntrinsics") = $true
        }
        $components.SaveChanges()
    }
}
$applications.SaveChanges()
}


<#
foreach ($application in $applications)
{
    
    
    if($application.name -like "TOPSAUDE*")
    {
        #$application.name
        #$comAdmin.ShutdownApplication($application.name)
    }
}

foreach ($application in $applications)
{
    if($application.name -like "TOPSAUDE*")
    {
        #$comAdmin.StartApplication("$application.name")
    }

}#>