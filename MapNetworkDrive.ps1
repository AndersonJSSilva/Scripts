########## funcoes do script ##########
function Get-NetworkDrivesbyPath($drivepath){            
    if (gwmi win32_logicaldisk -computer localhost -filter "drivetype=4" | ?{$_.ProviderName -eq "$drivepath"})
    {return 1}
    else{return 0} 
}

function Remove-NetworkDrive{            

    $net = New-Object -com WScript.Network            
    gwmi win32_logicaldisk -filter "drivetype=4" | %{$net.removenetworkdrive($_.deviceid,$true,$true)}
        
}   

function get-NetworkMapGroup($cgroup){
	$strGrpFilter = "(&(objectCategory=group)(name=$cGroup))"
	$objGrpSearcher = New-Object System.DirectoryServices.DirectorySearcher
	$objGrpSearcher.Filter = $strGrpFilter	
	$objGrpPath = $objGrpSearcher.FindOne()
    $objGrp = $objGrpPath.GetDirectoryEntry()
    $objGrp.description
}

function Novo-DriveRede{  
    Param(            
        [string]$Drive,            
        [string]$Unc,
        [array]$maps            
        )            
    
    $olddrive = Check-LastDriversLetters -path $unc -maps $maps
    if((Get-NetworkDrivesbyPath -drivepath $unc) -eq "0")
    {       
    $Return = Get-LetraDisponivel
    try{
    $net = New-Object -com WScript.Network            
    if ($drive)
    { 
        if($Return -contains $Drive)
        {        
            $Drive = ($Drive -replace ":","")+":"
            if($olddrive){$drive = $olddrive}
            $net.mapnetworkdrive($Drive,$Unc)
            "$Drive $UNC"
        }
        else
        {
            if($Return -eq $null)
            {$Drive = $null}
            else{$Drive = $return[0]}
            if($Drive)
            {
                $Drive = ($Drive -replace ":","")+":"
                if($olddrive){$drive = $olddrive}
                $net.mapnetworkdrive($Drive,$Unc)
                "$Drive $UNC" 
            }else
            {
                write-host "$UNC" Não possui letra disponível -ForegroundColor Red
            }

        }
    
    }else
    {
    
        
        if($Return -eq $null)
        {$Drive = $null}
        else{$Drive = $return[0]}
        if($Drive)
        {
            
            $Drive = ($Drive -replace ":","")+":"
            if($olddrive){$drive = $olddrive}
            $net.mapnetworkdrive($Drive,$Unc)
            "$Drive $UNC" 
        }else
        {
            write-host "$UNC" Não possui letra disponível -ForegroundColor Red
        }
    
    }            
             
    #$net.mapnetworkdrive($Drive, $Unc)            
    #$net.mapnetworkdrive($Drive+ ':',$Unc, $bProfile, $User, $password)  
    }catch{}

    }else{write-host $unc Drive já mapeado  -ForegroundColor Red }
             
} 

function Get-NetworkDrives{            
    return gwmi win32_logicaldisk -computer localhost -filter "drivetype=4" | select DeviceID,ProviderName   
}        

function Get-LetraDisponivel{
  67..90 | ForEach-Object { "$([char]$_):" } | 
  Where-Object { 
    (new-object System.IO.DriveInfo $_).DriveType -eq 'noRootdirectory' 
  }
} 

function Get-UserScriptPath($strName){
    
    $strFilter = "(&(objectCategory=User)(samAccountName=$strName))" 
    $objDomain = New-Object System.DirectoryServices.DirectoryEntry
    $objSearcher = New-Object System.DirectoryServices.DirectorySearcher
    $objSearcher.SearchRoot = $objDomain
    $objSearcher.Filter = $strFilter
    $objSearcher.SearchScope = "Subtree"
    $colProplist = "name","distinguishedname","scriptpath"
    foreach ($i in $colPropList){$objSearcher.PropertiesToLoad.Add($i)| Out-Null} 
    $colResults = $objSearcher.FindOne()
    foreach ($objResult in $colResults)
    {
        $objItem = $objResult.Properties;
        $dn = $objItem.distinguishedname
        $scriptpath = $objItem.scriptpath
        #Write-Host $objItem.distinguishedname  $objItem.scriptpath
    }
    if($scriptpath)
    {
        return 1
    }else
    {
        return 0
    }
}

function MapnetworkDrive($strName,$maps){
	
$strFilter = "(&(objectCategory=User)(samAccountName=$strName))"
$objSearcher = New-Object System.DirectoryServices.DirectorySearcher
$objSearcher.Filter = $strFilter
$objPath = $objSearcher.FindOne()
$objUser = $objPath.GetDirectoryEntry()
$DN = $objUser.distinguishedName
$ADVal = [ADSI]"LDAP://$DN"

if((Get-UserScriptPath $strName) -eq 0)
{

$grupos = $ADVal.memberOf

foreach($gpr in $grupos)
{
    $groupname = $gpr.Split(",")[0] -replace "CN=",""
    $gprdesc = get-NetworkMapGroup $groupname
    if($gprdesc){
    if($gprdesc.Substring(0,2) -eq "\\")
    {
        Novo-DriveRede -Unc $gprdesc -maps $maps       
    }
    }
}
}else{Write-Host Usuário possui script.bat e não irá mapear por Security Groups -ForegroundColor red}
}

function Kix-MapNetworkDrive($matricula){
$lines = Get-Content "\\unimedrj\netlogon\scripts\grupos_usuarios\membros.ini"
$user = $matricula.ToUpper()
$novoini = @()
$count = 0
    write-host "`n"
    #Write-Host $file.name -ForegroundColor Yellow
    #$lines = Get-Content $file.FullName
    foreach($line in $lines)
    {

        $count ++
        $tmpline = ($line.Trim()).ToUpper()
        #write-host Linha: $count 
        $tmpuser =$null
        if(($tmpline.StartsWith("[") -or $tmpline.StartsWith(" ") -or $tmpline.StartsWith(";") -or $tmpline.StartsWith("$user")))
        {
            if( $tmpline.StartsWith("[") -or $tmpline.StartsWith("$user"))
            {
                $novoini = $novoini + $tmpline
                
            } 
        }
    }
$kixs = @()
for($i = 0;$i -le $novoini.count; $i++)
{
     if($novoini[$i+1] -eq $user)
     {
        $kixs += $novoini[$i]
        #write-host $novoini[$i]
        #write-host $novoini[$i+1]
     }


}
$files = @()
$tomap = @()

if(test-path("\\unimedrj\netlogon\scripts\usuarios\$user.kix"))
{
    write-host possui "$user.kix" -ForegroundColor Green
   $tomap+= Get-Content "\\unimedrj\netlogon\scripts\usuarios\$user.kix"
}else
{
    write-host Nao possui mapeamento de usuário -ForegroundColor Red
}


$kixs | %{$files += ($_).substring(1,($_.length)-2)}
$files | %{write-host  $_".kix" -ForegroundColor Yellow;$tomap +=  Get-Content "\\unimedrj\netlogon\scripts\grupos_usuarios\$_.kix"}

for($i = 0;$i -lt $tomap.Length; $i++)
{
     if($tomap.GetValue($i)  -like "EnfileirarMapeamento*")
     {       
       $path = ((($tomap.GetValue($i) -replace "EnfileirarMapeamento","") -split ",")[0]) -replace '[(")]',""
       $letra = ((($tomap.GetValue($i) -replace "EnfileirarMapeamento","") -split ",")[1]) -replace '[( ")]',""
       #"$letra $path"
        

            if($path -contains $user)
            { Novo-DriveRede -Drive "G:" -Unc $path}
            else
            { Novo-DriveRede -Drive $letra -Unc $path}
        

    }
}
}

function Map-UserDriver{
$strName = $env:username
try{

    if(Test-Path \\arqprd01\$strName$ -ErrorAction Stop)
    {
        Novo-DriveRede -Drive "G:" -Unc "\\arqprd01\$strName$"
    }
    if(Test-Path \\arqprd02\$strName$ -ErrorAction Stop)
    {
        Novo-DriveRede -Drive "G:" -Unc "\\arqprd02\$strName$"
    }  
    
    }catch{}


}

function Check-LastDriversLetters($path,$maps){

for($i=0;$i-le $maps.length-1;$i++)
{
    if(($maps[$i].providername).ToUpper() -eq $path.ToUpper())
    {
        return [string]$maps[$i].DeviceID
        
    }
}
}


########## chamada do script ##########
[array]$maps = Get-NetworkDrives
$strName = $env:username
Remove-NetworkDrive
Novo-DriveRede -Drive "x:" -Unc "\\arqprd01\unimed$"
Map-UserDriver
#Kix-MapNetworkDrive $strName
MapnetworkDrive -strName $strName -maps $maps

#Write-Host Unidades de Rede Mapeadas -ForegroundColor Yellow
#Get-NetworkDrives | Ft -AutoSize
#Get-NetworkDrives | Ft -AutoSize | Out-File c:\temp\maps.log







