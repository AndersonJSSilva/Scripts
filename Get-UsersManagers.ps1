$usersfromfile = Get-Content c:\temp\usuario.txt
$usersout = $null
$usersout = @()
foreach($usuariof in $usersfromfile)
{
$users = Get-ADuser -filter {samaccountname -eq $usuariof} -Properties * -Server dcbar01.unimedrj.root | select -First 3
$users | select name
$usersout += "Login;Nome;Cargo;gestor1;gestor2;gestor3;gestor4"
foreach($usr in $users)
{
        $tmpusr = $null
        $str = $null
        
        $tmpusr = $usr 
        if($tmpusr)
        {
            $str = ($tmpusr.samaccountname).ToString()+";"
            if($tmpusr.name)
            {
                $str += ($tmpusr.name).ToString()+";"
            }else{
                $str += ";"
            }
            if($tmpusr.description)
            {
                $str += ($tmpusr.description).ToString()+";"
            }else{
                $str += ";"
            }
            if($tmpusr.manager)
            {
                $tmpmanager = (($tmpusr.manager).ToString() -replace "CN=","").Split(",")[0]
                $str += $tmpmanager+";"
                $tmpusr = $null
                $tmpusr = Get-ADUser -filter {name -like $tmpmanager} -Properties * -Server dcbar01.unimedrj.root
                if($tmpusr.Manager)
                {
                    $tmpmanager = (($tmpusr.manager).ToString() -replace "CN=","").Split(",")[0]
                    $str += $tmpmanager+";"
                      $tmpusr = $null
                $tmpusr = Get-ADUser -filter {name -like $tmpmanager} -Properties * -Server dcbar01.unimedrj.root
                if($tmpusr.Manager)
                {
                    $tmpmanager = (($tmpusr.manager).ToString() -replace "CN=","").Split(",")[0]
                    $str += $tmpmanager+";"
                      $tmpusr = $null
                $tmpusr = Get-ADUser -filter {name -like $tmpmanager} -Properties * -Server dcbar01.unimedrj.root
                if($tmpusr.Manager)
                {
                    $tmpmanager = (($tmpusr.manager).ToString() -replace "CN=","").Split(",")[0]
                    $str += $tmpmanager+";"

                }

                }

                }
                else {$str += ";"}

            }
            
            $str
            $usersout += $str
        }       
}
}

$saida = "C:\Temp\usermanagers_"+(Get-Date -Format yyyyMMddHHmmss).ToString() +".csv"
$usersout | Set-Content $saida -Encoding Unicode
Invoke-Command -ScriptBlock {cmd.exe /c 'C:\Program Files\Microsoft Office\Office15\excel.exe ' $saida}
