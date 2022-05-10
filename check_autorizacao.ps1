##Limpeza de Variáveis
$LogFile = @();
$OPMONStatus = @();
$comment = @();

#Variável com os arquivos de log
$LogFile = Select-String -Path C:\inetpub\wwwroot\tiss2\log\*solici*.log -pattern "<autorizacaoProcedimentoWS xmlns:xsi=""http://www.w3.org/2001/XMLSchema-instance"" xmlns:xsd=""http://www.w3.org/2001/XMLSchema"" xmlns=""http://www.ans.gov.br/padroes/tiss/schemas"" />","PL/SQL" 

#Saída do OPMON
if ($LogFile.length -le 5) 
 {
			$OPMONStatus = 0
		}else
        {
        if ($LogFile.length -ge 5){
			    $OPMONStatus = 2
			}
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
exit $OPMONStatus
 

