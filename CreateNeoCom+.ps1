$comAdmin = New-Object -comobject COMAdmin.COMAdminCatalog
$apps = $comAdmin.GetCollection(“Applications”)
$apps.Populate();

$newComPackageNames = @("TOPSAUDE - ACE", "TOPSAUDE - ANS", "TOPSAUDE - ASS", "TOPSAUDE - ATD", "TOPSAUDE - ATN", "TOPSAUDE - ATU", "TOPSAUDE - CAD", "TOPSAUDE - CAL", "TOPSAUDE - CAN", "TOPSAUDE - CAP", "TOPSAUDE - CLI", "TOPSAUDE - CMC", "TOPSAUDE - CMI", "TOPSAUDE - CMP", "TOPSAUDE - CMS", "TOPSAUDE - COF", "TOPSAUDE - COM", "TOPSAUDE - CTM", "TOPSAUDE - EGA", "TOPSAUDE - END", "TOPSAUDE - FEC", "TOPSAUDE - FAT", "TOPSAUDE - FSO", "TOPSAUDE - GEN", "TOPSAUDE - GER", "TOPSAUDE - HES", "TOPSAUDE - ITF", "TOPSAUDE - JUR", "TOPSAUDE - PAG", "TOPSAUDE - PEP", "TOPSAUDE - PRD", "TOPSAUDE - PRS", "TOPSAUDE - RBM", "TOPSAUDE - REC", "TOPSAUDE - REG", "TOPSAUDE - RGE", "TOPSAUDE - SUP", "TOPSAUDE - WRK")

foreach($newComPackageName in $newComPackageNames)
{
$appExistCheckApp = $apps | Where-Object {$_.Name -eq $newComPackageName}

if($appExistCheckApp)
{
$appExistCheckAppName = $appExistCheckApp.Value(“Name”)
“Este COM+ Application já existe : $appExistCheckAppName”
}
Else
{
$newApp1 = $apps.Add()
$newApp1.Value(“Name”) = $newComPackageName
$newApp1.Value(“ApplicationAccessChecksEnabled”) = 0 <# Security Tab, Authorization Panel, “Enforce access checks for this application #>
$newApp1.Value("Activation") = 1 
$newApp1.Value("Description") = "Neo Com+ Application"
$newApp1.Value(“Identity”) = “topdown”
$newApp1.Value(“Password”) = “topdown”
$newApp1.Value("RunForever") = $False

#Parametros customizados "TOPSAUDE - FAT"
If ($newComPackageName -eq "TOPSAUDE - FAT")
{
$newApp1.Value("ConcurrentApps") = 1
$newApp1.Value("RecycleLifetimeLimit") = 0
$newApp1.Value("RecycleMemoryLimit") = 0
$newApp1.Value("RecycleCallLimit") = 800000
$newApp1.Value("RecycleActivationLimit") = 0
$newApp1.Value("RecycleExpirationTimeout") = 15
}

#Parametros customizados "TOPSAUDE - GEN"
If($newComPackageName -eq  "TOPSAUDE - GEN")
{
$newApp1.Value("ConcurrentApps") = 3
$newApp1.Value("RecycleLifetimeLimit") = 10
$newApp1.Value("RecycleMemoryLimit") = 307200
$newApp1.Value("RecycleCallLimit") = 0
$newApp1.Value("RecycleActivationLimit") = 0
$newApp1.Value("RecycleExpirationTimeout") = 15
}
$saveChangesResult = $apps.SaveChanges()
“Resultado da operacao de SaveChanges : $saveChangesResult”

$com = ($newComPackageName.Substring($newComPackageName.Length-3)).ToLower()
$path = "e:\topsaude\web\"+$com+"\com\"
$dlls = Get-ChildItem $path -Exclude genFileSystemObject.dll,XZip.dll,Certificado.dll,certificado.reg,certificado.tlb
foreach($dll in $dlls)
{
    
    ($dll.FullName).ToString()
    $comAdmin.InstallComponent($newComPackageName,($dll.FullName).ToString(),"","")    

}

foreach ($application in $apps)
{    
    if ($application.Name -like $newComPackageName)
    {
        $application.name
        $components = $apps.GetCollection("Components",$application.key)
        $components.Populate()

        foreach ($component in $components)
        {
        $component.name       
        $component.Value("IISIntrinsics") = $true
        }
        $components.SaveChanges()
    }
}


}
}