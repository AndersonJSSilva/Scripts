$entrada = Get-Content c:\temp\gruposureh.txt

foreach($gpr in $entrada)
{
    if (Get-ADGroup -Filter {name -eq $gpr} -Server adsrv33.uremh.local)
    {
        $gpr + ";existe"
    }
    else{
        $gpr + ";nao existe"

    }
}


############################################################################

$entrada = Get-Content c:\temp\gruposcoop.txt

foreach($gpr in $entrada)
{
    if (Get-ADGroup -Filter {name -eq $gpr})
    {
        $gpr + ";existe"
    }
    else{
        $gpr + ";nao existe"

    }
}