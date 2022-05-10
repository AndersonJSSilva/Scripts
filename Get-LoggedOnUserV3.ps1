Get-ADComputer -LDAPFilter "(name=*)" -SearchBase "OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"


$computers = Get-ADComputer -SearchBase "OU=_Benfica,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root" -Filter '*' | Select -Exp Name
$computers.Count




function Get-LoggedOnUser { 
#Requires -Version 2.0             
[CmdletBinding()]             
 Param              
   (                        
    [Parameter(Mandatory=$true, 
               Position=0,                           
               ValueFromPipeline=$true,             
               ValueFromPipelineByPropertyName=$true)]             
    [String[]]$ComputerName 
   )#End Param 
 
Begin             
{             
 Write-Host "`n Checking Users . . . on" $ComputerName
 $i = 0             
}#Begin           
Process             
{ 
    $ComputerName | Foreach-object { 
    $Computer = $_ 
    try 
        { 
            $processinfo = @(Get-WmiObject -class win32_process -ComputerName $Computer -EA "Stop") 
                if ($processinfo) 
                {     
                    $processinfo | Foreach-Object {$_.GetOwner().User} |  
                    Where-Object {$_ -ne "SERVIÇO DE REDE" -and $_ -ne "SERVIÇO LOCAL" -and $_ -ne "SISTEMA"} | 
                    Sort-Object -Unique | 
                    ForEach-Object { New-Object psobject -Property @{Computer=$Computer;LoggedOn=$_} } |  
                    Select-Object Computer,LoggedOn 
                }#If 
        } 
    catch 
        { 
            "Cannot find any processes running on $computer" | Out-Host 
        } 
     }#Forech-object(Comptuters)        
             
}#Process 
End 
{ 
 
}#End 
 
}


$maquinas = Get-Content -Path C:\temp\Micros.txt
$saida = @()
foreach($maq in $maquinas)
{
   $saida += Get-LoggedOnUser -ComputerName $maq
}
$saidauser = @()
foreach($out in $saida)
{
  $tmpuser= get-aduser -identity $out.LoggedOn -Properties * | select name, department

  $outinfo = new-object PSObject
  $outinfo  | add-member -type NoteProperty -Name "Maquina" -Value $out.Computer
  $outinfo  | add-member -type NoteProperty -Name "LoggedOn" -Value  $out.LoggedOn
  $outinfo  | add-member -type NoteProperty -Name "Name" -Value $tmpuser.name
  $outinfo  | add-member -type NoteProperty -Name "Department" -Value $tmpuser.department
  $saidauser += $outinfo

}
$saidauser | Export-Csv -Path C:\temp\c42h.csv


Search-Mailbox -identity teste_ti -searchquery {(Received:> 01/01/2016 and Received:< 01/03/2016)} -DeleteContent

Search-Mailbox -identity m50610 -searchquery "Received:(03/08/2016..03/09/2016)" -DeleteContent
