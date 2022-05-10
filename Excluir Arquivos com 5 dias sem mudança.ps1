##VERIFICAÇÃO DE ARQUIVOS
$arquivos = Get-ChildItem -Path c:\teste\ -Recurse

##BUSCA DE DATA
$data = Get-Date

##CONDICIONAL PARA IDENTIFICAR ARQUIVOS E DIRETÓRIOS COM 5 DIAS SEM UTILIZAÇÃO E DELETÁ-LOS
foreach ($file in $arquivos){
if ($file.lastwritetime -lt $data.AddDays(-5))
    {
    write-host $file
    $file.Delete()
    }
}


