#Limpeza de Variáveis
$LogFile = @();
$OPMONStatus = @();
$CheckError = @();
$comment = @();

#Variável com os arquivos de log
$LogFile = Get-Content D:\TopSaude\WEB\API.SMS\logsms*

#Identificação da Palavra no Log
$CheckError = $LogFile | where { $_ -match "Internal Server Error" }

#Saída do OPMON
if ($CheckError -eq $null) 
		{
			$OPMONStatus = 0
		}
        else
		    {
			    $OPMONStatus = 2
			}

#Comentário da Saída		
if ($OPMONStatus -eq 2) 
{
    $comment = "Arquivos de Log com Erro"
} 	
    if ($OPMONStatus -eq 0)
        {
            $comment = "Arquivos de Log sem Erro"
        } 
    Write-Host $comment
exit	
 

