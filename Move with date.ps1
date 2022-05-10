$iisopme = Get-ChildItem -Path '\\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\' | ?{$_.psiscontainer}
$iisopme.Count

$path2014 = "\\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\2014\"
$path2013 = "\\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\2013\"
$path2012 = "\\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\2012\"

New-Item -Path \\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\ -Name 2014 -ItemType directory
New-Item -Path \\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\ -Name 2013 -ItemType directory
New-Item -Path \\hostv0015\E$\Inetpub\wwwroot\unimed\opme20\dbarquivos\ -Name 2012 -ItemType directory

foreach($folder in $iisopme)
{
    
    
    
    if($folder.CreationTime.Year -eq "2014")
    {

        Move-Item $folder.FullName -Force -Destination $path2014

    }
    if($folder.CreationTime.Year -eq "2013")
    {

        Move-Item $folder.FullName -Force -Destination $path2013

    }
    if($folder.CreationTime.Year -eq "2012")
    {

       Move-Item $folder.FullName -Force -Destination $path2012

    }

}