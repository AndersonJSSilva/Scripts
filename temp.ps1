Copy-Item -Path \\neoappprd01\e$\TopSaude\web\Neo.site\Log\wbslog*.* -Destination C:\temp\logswbs\server01\site\
Copy-Item -Path \\neoappprd02\e$\TopSaude\web\Neo.site\Log\wbslog*.* -Destination C:\temp\logswbs\server02\site\
Copy-Item -Path \\neoappprd03\e$\TopSaude\web\Neo.site\Log\wbslog*.* -Destination C:\temp\logswbs\server03\site\
Copy-Item -Path \\neoappprd04\e$\TopSaude\web\Neo.site\Log\wbslog*.* -Destination C:\temp\logswbs\server04\site\
Copy-Item -Path \\neoappprd01\e$\TopSaude\web\Neo.WS\Log\wbslog*.* -Destination C:\temp\logswbs\server01\ws\
Copy-Item -Path \\neoappprd02\e$\TopSaude\web\Neo.WS\Log\wbslog*.* -Destination C:\temp\logswbs\server02\ws\
Copy-Item -Path \\neoappprd03\e$\TopSaude\web\Neo.WS\Log\wbslog*.* -Destination C:\temp\logswbs\server03\ws\
Copy-Item -Path \\neoappprd04\e$\TopSaude\web\Neo.WS\Log\wbslog*.* -Destination C:\temp\logswbs\server04\ws\

$files = Get-ChildItem -Path C:\temp\logswbs\ -Recurse |r
$files | ft FullName,Length,LastWriteTime

$files = Get-Childitem 'Z:\*.jpg-Catia' -Recurse | where { -not $_.PSIsContainer } | select extension -Unique
$files | sort -Desc | Set-Content c:\temp\extensoesAM.txt
$files | group Extension -NoElement | sort count -desc

Get-ChildItem C:\temp\ -Recurse | select extension -Unique | where { -not $_.PSIsContainer } | group Extension -NoElement | sort count -desc



