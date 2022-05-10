function Check-UserMapsADGroup($matricula){
$name = @()
$groups = Get-ADUser -Filter {samaccountname -eq $matricula} -Properties * | select memberof -ExpandProperty memberof
$groups | %{$name += (($_ -split ",")[0] -replace "CN=","")}
$name | %{}
foreach($n in $name){

    $gptmp = Get-ADGroup -filter {name -eq $n} -Properties * | select name, description, info,  @{Label="managedby";Expression={($_.managedby -split ",")[0] -replace "CN=",""}}
    if(($gptmp.description).Length -gt 1)
    {
            if(($gptmp.description).Substring(0,2) -eq "\\")
            {
                $gptmp
            }
    }
    
}
}

Check-UserMapsADGroup "M67423"
Verify-userMapskix "m70041"


$shares = Get-Content C:\temp\gruposUREMH.txt
foreach($share in $shares)
{
        $name = Remove-Acentos ((($share -split '\\')[($share -split '\\').Length - 1] -replace "[$]","")-replace " ","_").ToLower()
        $server = ($share -split '\\')[2]
        #$share
        #$server
        $name = "_UREH_ND_"+$name
        write-host $name " -> " $server " -> " $share
        #New-ADGroup  -Name $name  -GroupCategory Security -GroupScope Global -Path $path -Description $share
}



$path = "OU=Grupo de Segurança e Distribuição,OU=_Barra,DC=unimedrj,DC=root"
New-ADGroup  -Name '_UREH_ND__Anexo_de_Autorizacao'  -GroupCategory Security -GroupScope Global -Path $path -Description "\\arqprd01\financas$"

$desc = '*arqprd01\g*'
Get-ADGroup -filter {Description -like $desc} -Properties * | select name, Description, samaccountname  | Sort-Object description |ft -AutoSize


(Get-ADGroup -filter {Description -like "*arqprd01*"} -Properties * ).count

New-ADGroup  -Name '_UREH_ADM_Anexo_de_Autorizacao'  -GroupCategory Security -GroupScope local -Path $path -Description "\\unirjhfs01\Hospital\Anexo_de_Autorizacao"
New-ADGroup  -Name '_UREH_USER_Anexo_de_Autorizacao'  -GroupCategory Security -GroupScope local -Path $path -Description "\\unirjhfs01\Hospital\Anexo_de_Autorizacao"
