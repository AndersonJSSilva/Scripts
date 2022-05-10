$servidor = Read-Host "Servidor"
$comAdmin = New-Object -com ("COMAdmin.COMAdminCatalog.1")
$comAdmin.Connect($servidor)
$applications = $comAdmin.GetCollection("Applications") 
$applications.Populate() 

$ArrayCOMPlus = @{} 
$ProcessDLLHost = Get-WmiObject -Query "select * from win32_process where Name like 'dllhost%'" -ComputerName $servidor 
$ProcessDLLHost | foreach { 
    # select WMI processID 
    $processID = $_.ProcessId
    #Write-Host $processID 
    # Get Instance from PID 
    $oAppInstance=$comAdmin.GetApplicationInstanceIDFromProcessID($processID) 
        # verify if Instance not exists 
        If (-not ($ArrayCOMPlus.ContainsKey("$oAppInstance"))){ 
            # add Instance ID and PID 
            $ArrayCOMPlus.add($oAppInstance, $processID) 
        } 
    }

# get application         
$applications = $comAdmin.getcollection("Applications") 
$applications.populate() 
foreach ($application in $applications){ 
    $skeyappli = $application.key 
    $oappliInstances = $applications.getcollection("ApplicationInstances",$skeyappli) 
    $oappliInstances.populate() 
    # verify if application is started 
    If ($oappliInstances.count -eq 0) { 
        #Write-Host "Aplicacao"$application.value("Name")"nao esta rodando `n" -ForegroundColor Red 
        } Else{ 
            Write-Host "Aplicacao"$application.value("Name")"esta em execucao " -ForegroundColor Green 
            foreach ($Oinstance in $oappliInstances){ 
                Write-host "`t Instance ID:"$Oinstance.value("InstanceID") 
                Write-host "`t Process ID :"$ArrayCOMPlus.get_item($Oinstance.value("InstanceID"))"`n" 
            } 
            
        } 
    } 

$ArrayCOMPlus = $oappliInstances = $applications = $comAdmin = $ProcessDLLHost = $Null 
 


