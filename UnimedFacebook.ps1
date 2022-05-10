Import-module C:\powershell\UnimedrioWorkplaceFunctions.ps1

Measure-Command -Expression {}

$usersAD = Get-ADGroupMember workplaceusers | get-aduser -Properties mail, enabled, description, department, officephone, manager
$usersAD += Get-ADGroupMember workplaceusers -Server adsrv33.uremh.local | get-aduser -Properties mail, enabled, description, department, officephone, manager
$usersfb = UnimedWorkplace-GetAllUsers | ?{($_.active -eq $true)}# | ?{($_.active -eq $true) -and ($_.username -like "*@unimedrio.com.br")}
$usersAD.count
$usersfb.count
$desabilitar = @()
$criar = @()
$habilitar = @()
#verifica os usuários que sairam do grupo WorkplaceUsers no AD e serão desabilitados
Write-Host Procurando usuários para desabilitar no Workplace -BackgroundColor Yellow -ForegroundColor Black
$arraytmp = ($usersAD | %{$_.mail} | Sort-Object)
foreach($fb in $usersfb)
{    
    $tmp = $fb.username
    if($arraytmp -match $tmp)
    {
        if((($usersAD | ?{$_.mail -eq $tmp}).enabled -eq $false) -and (($usersfb | ?{$_.username -eq $tmp}).active -eq $true))
        {
            Write-Host $tmp -> está desabilitado no AD -> Desabiltar no Workplace -BackgroundColor Red
            $desabilitar += $tmp
        }        
    }else{
        if(($usersfb | ?{$_.username -eq $tmp}).active -eq $true)
        {
            Write-Host $tmp -> não está no grupo workplaceUsers do AD -> Desabilitar no Workplace -BackgroundColor Red
            $desabilitar += $tmp
        }

    }
}
#verifica os usuários que entraram no grupo WorkplaceUsers no AD e serão criados no Workplace
Write-Host Procurando usuários para criar/habilitar no Workplace -BackgroundColor Yellow -ForegroundColor Black
foreach($ad in $arraytmp)
{   
    if($usersfb -match $ad)
    {
        if((($usersAD | ?{$_.mail -eq $tmp}).enabled -eq $true) -and (($usersfb | ?{$_.username -eq $ad}).active -eq $false))
        {
            Write-Host $ad -> está habilitado no AD -> Habilitar no Workplace -BackgroundColor Red
            $habilitar += $ad
        }
    }else{
        if(($usersAD | ?{$_.mail -eq $tmp}).enabled -eq $true)
        {
            Write-Host $ad -> está no AD e não está no Workplace -> Criar no Workplace -BackgroundColor Red
            $criar += $ad  
        }
    }
} 



$desabilitar
$habilitar
$criar 


$idmanager =(UnimedWorkplace-GetUser -email bruno.souza@unimedrio.com.br).id
UnimedWorkplace-SetManager -usuario (UnimedWorkplace-GetUser -email "aline.vaughon@unimedrio.com.br") -idmanager $idmanager



$emails =@("carlos.david@unimedrio.com.br")           
$idmanager = UnimedWorkplace-getUserId -email jorge.cruz@unimedrio.com.br
foreach($email in $emails)
{ 
    $usuario = UnimedWorkplace-GetUser -email $email
    if($usuario -and $idmanager)
    {
        UnimedWorkplace-SetManager -usuario $usuario -idmanager $idmanager
    }
}


$aduser = get-aduser -filter {mail -eq "fernanda.fernandes@unimedrio.com.br"} -Properties *

$usuario = UnimedWorkplace-GetUser -email carlos.david@unimedrio.com.br
$userwrk = UnimedWorkplace-GetUser -email gustavo.rangel@unimedrio.com.br
$userwrk.PSObject.Properties.Remove("urn:scim:schemas:extension:facebook:starttermdates:1.0")
$userwrk.PSObject.Properties.Remove("urn:scim:schemas:extension:facebook:accountstatusdetails:1.0")
$userwrk.schemas = $userwrk.schemas | ?{$_ -ne "urn:scim:schemas:extension:facebook:starttermdates:1.0"}
$userwrk.schemas = $userwrk.schemas | ?{$_ -ne "urn:scim:schemas:extension:facebook:accountstatusdetails:1.0"}
$userwrk | ConvertTo-Json

$userwrk.'urn:scim:schemas:extension:enterprise:1.0'.manager.managerId.gettype()


UnimedWorkplace-DisabelUser -user (UnimedWorkplace-GetUser -email leandro.diniz@unimedrio.com.br)

$alluser= UnimedWorkplace-GetAllUsers 
$alluser.Count
($alluser | ?{($_.username -like "*unimedrio.com.br") -and ($_.active -eq $false)}).count 
($alluser | ?{$_.username -like "*unimedrio.com.br"  -or  $_.username -like "*unimedrioempreendimentos.com.br"  -or $_.username -like "*centrodeexcelenciafisica.com.br"}).count 


$alluser | ?{$_.username -notlike "*unimedrio.com.br"  -and  $_.username -notlike "*unimedrioempreendimentos.com.br"  -and $_.username -notlike "*centrodeexcelenciafisica.com.br"}

($alluser | ?{$_.username -like "*unimedrio.com.br"}).count 
($alluser | ?{$_.username -like "*unimedrioempreendimentos.com.br"}).count 
($alluser | ?{$_.username -like "*centrodeexcelenciafisica.com.br"}).count
($alluser | ?{$_.username -like "*centrodeexecelenciafisica.com.br"}).count  

$alluser | ?{$_.username -like "*centrodeexcelenciafisica.com.br"} | ft * -AutoSize
$alluser | ?{$_.username -like "*centrodeexecelenciafisica.com.br"}| ft * -AutoSize 

$alluser | Export-Csv c:\temp\workusers.csv -Encoding Unicode


($alluser |?{($_.manager -eq $null) -and $_.username -like "*unimedrio.com.br"}).count

$alluser |?{($_.manager -eq $null) -and $_.username -like "*unimedrio.com.br"} | select username

#### Atualiza usuário ####
$email = "luciana.gomes@unimedrio.com.br"
$aduser = Get-ADUser -Filter {mail -eq $email} -properties *
UnimedWorkplace-UpdateUser -aduser $aduser -userwrk (UnimedWorkplace-GetUser -email $email)
################################################################################################

Measure-Command -Expression {
foreach ($user in $alluser)
{

    
    $email = $user.username
    $aduser = Get-ADUser -Filter {mail -eq $email} -properties *
    UnimedWorkplace-UpdateUser -aduser $aduser -userwrk (UnimedWorkplace-GetUser -email $email)

}

}

$aduser = Get-ADUser -Filter {mail -eq "jeferson.gomes@unimedrio.com.br"} -Properties *
UnimedWorkplace-CreateUser -aduser $aduser