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


$maquinas = Get-Content  
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
$saidauser
