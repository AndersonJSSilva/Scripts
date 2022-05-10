$folders = Get-Content C:\temp\dbarquivos.txt
$bkpdir = "\\spoappprd01\f$\BKP_HOSTV0015_dbarquivos\"
$folderopme = "\\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\"
$iisopme = Get-ChildItem -Path '\\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\'
$iisopme.count

$iisopme | select name, CreationTime


#### Monta os arrays com as pastas que existem e nao existem
$exist = @()
$notexist = @()
foreach ($folder in $folders)
{
    $tmp = $folderopme+$folder
    if(!(Test-Path $tmp))
    {
        $notexist += $tmp
    }else
    {
        $exist += $tmp
    }

    $tmp=""
}
$exist.count
$notexist.count
###########################################################

######## efetua o bkp das pastas##########################
foreach($folder in $exist)
{    
    Copy-Item $folder -Destination $bkpdir -Recurse -Force
}
(Get-ChildItem -Path $bkpdir).count
###########################################################
##################### remove as pastas backupeadas #######
foreach($folder in $exist)
{    
    Remove-Item $folder -Recurse -Force
}
###########################################################

$exist | Set-Content c:\temp\Pastasremovidas.txt

(Get-ChildItem -Path '\\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\').count


