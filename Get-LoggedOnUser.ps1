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
 Write-Host "`n Checking Users . . . "
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
     }#Forech-object(ComputerName)       
            
}#Process
End
{

}#End

}
$pcs = Get-Content C:\temp\dhcpsuporte.csv
foreach($pc in $pcs)
{
    Get-LoggedOnUser ($pc -split ",")[0]
    
}