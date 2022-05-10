$files = Get-ChildItem \\unimedrj\netlogon\scripts\grupos_usuarios\unisas*.kix
$files.Count
$naoexiste = 0
$existe = 0

foreach($file in $files)
{
    $nametmp = $file.name -replace ".kix",""
    #Write-Host $file.Name -ForegroundColor Yellow
    Get-Content $file.FullName
   <# if (get-aduser -Filter {samaccountname -eq $nametmp} | select name)
    {
        Write-Host $nametmp  existe -ForegroundColor Green
        $existe ++
    }else{
        Write-Host $nametmp não existe -ForegroundColor Red
        $naoexiste ++
        #Remove-Item -Path $file.FullName
    }#>

}
$existe
$naoexiste

############################################################ revalidar membros ini
$files = Get-ChildItem C:\temp\membros.ini
$files.Count
$novoini = $null
$removidos = $null
$count = 0
foreach($file in $files)
{
    Write-Host $file.name -ForegroundColor Yellow
    $lines = Get-Content $file.FullName
    foreach($line in $lines)
    {

        $count ++
        $tmpline = $line.Trim()
        #write-host Linha: $count 
        $tmpuser =$null
        if(($line.StartsWith("[") -or $line.StartsWith(" ") -or $line.StartsWith(";")))
        {
            if( ($line.StartsWith("[")) )
            {
                $novoini = $novoini + $tmpline+"`n"
                $removidos = $removidos + $tmpline+"`n"
            } else 
            {
               if( ($line.StartsWith(" ")) )
               {
                    $novoini = $novoini + "`n"
               }else {
               
                   if( ($line.StartsWith(";")) )
                   {
                       $removidos = $removidos + $tmpline+"`n"
                   }
               }     
            }
        }else
        {
            #$line
            if($tmpline)
            {
                
                $tmpuser = Get-ADUser -Filter {samaccountname -eq $tmpline} | select name
                if($tmpuser)
                {
                    #$tmpline + ""
                    $novoini = $novoini + $tmpline +"`n"#+" "+ $tmpuser.name+"`n"
                }else{
                    #$line + " usuário nao existe"
                    $removidos = $removidos + $tmpline+"`n"
                }

            } else {
                #$tmpline + "não tem valor"
                $novoini = $novoini + "`n"            
            }                 

        }   


    }
}
$novoini
$removidos
##############################################################################################



################################################################ membros.ini para matrula x
$matricula = "m47333"
$files = Get-ChildItem C:\temp\membros.ini
$files.Length
$novoini = $null
$count = 0
foreach($file in $files)
{
    Write-Host $file.name -ForegroundColor Yellow
    $lines = Get-Content $file.FullName
    foreach($line in $lines)
    {

        $count ++
        $tmpline = $line.Trim()
        #write-host Linha: $count 
        $tmpuser =$null
        if(($line.StartsWith("[") -or $line.StartsWith(" ") -or $line.StartsWith(";") -or $line.StartsWith($matricula)))
        {
            if( $line.StartsWith("[") -or $line.StartsWith($matricula) )
            {
                $novoini = $novoini + $tmpline+"`n"
                
            } else 
            {
               if( ($line.StartsWith(" ")) )
               {
                    $novoini = $novoini + "`n"
               }     
            }
        }
    }
}
$novoini

#############################################################################################
$user = ("c2").ToUpper()
################################################################ membros.ini mapeamentos do usuário xxxx
function Verify-userMapskix($matricula){
#Copy-Item \\unimedrj\netlogon\scripts\grupos_usuarios\membros.ini C:\temp\membros.ini
$files = Get-ChildItem C:\temp\membros.ini
$user = $matricula.ToUpper()
#write-host "`n"
#$files.Length
$novoini = @()
$count = 0
foreach($file in $files)
{
    #write-host "`n"
    #Write-Host $file.name -ForegroundColor Yellow
    $lines = Get-Content $file.FullName
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
}
#$novoini
#write-host "`n"
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
#write-host "`n"
$files = @()
$kixs | %{$files += ($_).substring(1,($_.length)-2)}
$files | %{write-host  $_".kix" -ForegroundColor Yellow;Get-Content "\\unimedrj\netlogon\scripts\grupos_usuarios\$_.kix"}

#write-host "`n"
if(test-path("\\unimedrj\netlogon\scripts\usuarios\$user.kix"))
{
    write-host possui mapeamento de usuário -ForegroundColor Green
    write-host "`n"
    Get-Content "\\unimedrj\netlogon\scripts\usuarios\$user.kix"

}else
{
    #write-host Nao possui mapeamento de usuário -ForegroundColor Red

}
}

Verify-userMapskix "m70041"
MapnetworkDrive "e1026"

##############################################################################################
Get-Content C:\temp\usersmembro.txt | %{write-host $_ + "`n" -ForegroundColor Green; Verify-userMapskix $_}
################################################################ mapear unidades de rede baseada no KIX

$matricula = "m50610"

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
$kixs | %{$files += ($_).substring(1,($_.length)-2)}
$files | %{write-host  $_".kix" -ForegroundColor Yellow;$tomap +=  Get-Content "\\unimedrj\netlogon\scripts\grupos_usuarios\$_.kix"}
if(test-path("\\unimedrj\netlogon\scripts\usuarios\$user.kix"))
{
    write-host possui "$user.kix" -ForegroundColor Green
    write-host "`n"
   $tomap+= Get-Content "\\unimedrj\netlogon\scripts\usuarios\$user.kix"

}else
{
    write-host Nao possui mapeamento de usuário -ForegroundColor Red

}
for($i = 0;$i -lt $tomap.Length; $i++)
{
     if($tomap.GetValue($i)  -like "EnfileirarMapeamento*")
     {       
       $path = ((($tomap.GetValue($i) -replace "EnfileirarMapeamento","") -split ",")[0]) -replace '[(")]',""
       $letra = ((($tomap.GetValue($i) -replace "EnfileirarMapeamento","") -split ",")[1]) -replace '[( ")]',""
       #"$letra $path"
        
        $drvexist = Get-NetworkDrivesbyPath -drivepath $path
        if($drvexist -eq "0")
        {
            Novo-DriveRede -Drive $letra -Unc $path
        
        }else{ write-host $path Drive já mapeado  -ForegroundColor Red }
    }
}
}

Get-NetworkDrives
#Remove-NetworkDrive
Kix-MapNetworkDrive $matricula
MapnetworkDrive $matricula


##############################################################################################





$files = Get-ChildItem C:\temp\membros.ini
$files.Count
foreach($file in $files)
{
    Write-Host $file.name -ForegroundColor Yellow
    $lines = Get-Content $file.FullName
    foreach($line in $lines)
    {

        if($line.length -gt 1)
        {
            #$line.Substring(0,1)    
            if(($line.Substring(0,1) -eq "[") )
            {
                $line

            }
        }
    }
}


$files = Get-ChildItem \\unimedrj\netlogon\scripts\grupos_usuarios\membros.ini
$files.Count
foreach($file in $files)
{

    Write-Host $file.name -ForegroundColor Yellow
    (Get-Content $file.FullName).Substring(1,0)

}


$files = Get-ChildItem \\unimedrj\netlogon\scripts\usuarios\*.kix
$files.Count
foreach($file in $files)
{

    Write-Host $file.name -ForegroundColor Yellow
    Get-Content $file.FullName

}


$shares = Get-Content C:\temp\shares.txt
foreach($share in $shares){


$tmpshare = ($share -split "\\")[2]
$share
if(Test-Connection $tmpshare)
{
    write-host Exist
}else
{
    write-host não existe

}

}


#######################################################
$lines = Get-Content C:\temp\exec.txt
$user = "e1002"
$files.Count
foreach($line in $lines)
{
    Write-Host $line -ForegroundColor Yellow
    Get-Content "\\unimedrj\netlogon\scripts\grupos_usuarios\$line.kix"

}
try {Get-Content "\\unimedrj\netlogon\scripts\usuarios\$user.kix" -ErrorAction Stop}catch{}

#######################################################

Copy-Item \\unimedrj\netlogon\scripts\grupos_usuarios\membros.ini C:\temp\membros.ini

Get-ADUser -Filter {samaccountname -like "e10*"} | select samaccountname, name