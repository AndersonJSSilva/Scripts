#Limpeza de Variáveis
$Printers = @();

$excecao = @(
"\\prtsrv01\Samsung CLP-775 Series - 10.200.60.52 (COLOR)",
"\\prtsrv02\Impressoras Unimed Rio"
)

#Excluir Impressoras
$Printers = Get-WmiObject -Class Win32_Printer
foreach($Printer in $Printers)
{
    if($Printer.Name -like "\\prtsrv*" -and $Printer.Name -notin $excecao)
    {
        $Printer.Delete();
    }
}

##Adicionar Impressora Padrão caso nao esteja instalada
$achou = $false
foreach($Printer in $Printers)
{
    if($Printer.Name -eq "\\prtsrv02\Impressoras Unimed Rio" )
    {
        $achou = $true
    }    
}
if(!$achou)
{
    try{
        (New-Object -ComObject WScript.Network -ErrorAction Stop).AddWindowsPrinterConnection("\\prtsrv02\spool_unimed")
        (Get-WmiObject -Class Win32_Printer -Filter "ShareName='SPOOL_UNIMED'" -ErrorAction Stop).SetDefaultPrinter()
       }catch{$_.message}
}

