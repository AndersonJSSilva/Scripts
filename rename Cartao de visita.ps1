$files = Get-ChildItem C:\temp\cv\Documents\ -Include *.pdf -Recurse
foreach($file in $files)
{
    $name = $file.BaseName
    $path = $file.Directory
    $jpg = Get-ChildItem -Path "$path\*.jpg"
    Rename-Item $jpg -NewName "$name.jpg"
}
$jpgs = Get-ChildItem C:\temp\cv\Documents\ -Include *.jpg -Recurse
$jpgs | %{Move-Item $_ -Destination c:\temp\cv\}