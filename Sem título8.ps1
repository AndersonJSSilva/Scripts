$shares = Import-Csv C:\temp\sharesarqprd01.csv
$shares = Import-Csv C:\temp\sharesarqprd02.csv
$shares = Import-Csv C:\temp\sharesarqprd03.csv

foreach($shr in $shares)
{
    #write-host $shr.ShareName -ForegroundColor Yellow
    $tmp = "_user"+$shr.ShareName -replace "[$]",""
    $group = Get-ADGroup -Filter {name -like $tmp} -Properties * | select name, description
    if(!$group)
    {
        write-host $shr.ShareName \\arqprd02\($shr.ShareName).ToString() -ForegroundColor Red
    }else
    {
        write-host $group.name $group.description -ForegroundColor green
    }
    $tmp = "_adm"+$shr.ShareName -replace "[$]",""
    $group = Get-ADGroup -Filter {name -like $tmp} -Properties * | select name, description
    if(!$group)
    {
        write-host $shr.ShareName \\arqprd02\($shr.ShareName).ToString() -ForegroundColor Red
    }else
    {
        write-host $group.name $group.description -ForegroundColor green
    }



    $tmp = $null
}



