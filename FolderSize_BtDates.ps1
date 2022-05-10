(Get-Date).AddDays(-3)
(Get-Date).AddDays(-10)

$tamanho = 0
$files = Get-ChildItem -Recurse -Include *.* | where-object {($_.CreationTime -gt (Get-Date).AddDays(-10)) -and ($_.CreationTime -lt (Get-Date).AddDays(-3))}
foreach ($file in $files)
{
   $tamanho += $file.Length 
} 
write-host ((($tamanho)/1024)/1024) "MB"

