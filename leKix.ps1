$users = Get-Content C:\temp\userskix.txt
$users | %{$tmpaduser = Get-ADUser -Filter {samaccountname -eq $_};if(!($tmpaduser)){$_ + " nao encontrado"}else{$tmpaduser.name} }
 

$files = Get-ChildItem \\unimedrj\netlogon\scripts\usuarios\*.kix
$files.Count
$naoexiste = 0
$existe = 0

foreach($file in $files)
{
    $nametmp = $file.name -replace ".kix",""
    Write-Host $file.Name -ForegroundColor Yellow
    Get-Content $file.FullName
   <# if (get-aduser -Filter {samaccountname -eq $nametmp} | select name)
    {
        Write-Host $nametmp  existe -ForegroundColor Green
        $existe ++
    }else{
        Write-Host $nametmp não existe -ForegroundColor Red
        $naoexiste ++
        #Remove-Item -Path $file.FullName
    }#>

}
$existe
$naoexiste
 
