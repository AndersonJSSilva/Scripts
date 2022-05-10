$jogo = $null

$jogo = (
@("25","33","41","43","49","58"),
@("9","21","27","39","48","60"),	 	 	 
@("1","10","13","15","29","60"),	 	 	 
@("4","8","9","18","36","57"),	 	 	 
@("14","17","20","24","35","59"),	 	 	 
@("13","18","23","28","36","44"),	 	 	 
@("2","5","25","43","53","55"),	 	 	 
@("26","37","40","45","49","59"),	 	 	 
@("3","5","10","24","31","58"),	 	 	 
@("7","26","38","45","52","59"),

@("8","9","14","23","49","55"),
@("10","18","32","38","44","57"),	 	 	 
@("15","18","22","25","37","41"),	 	 	 
@("1","8","21","27","42","51"),	 	 	 
@("21","50","51","52","58","60"),	 	 	 
@("2","6","8","21","25","27"),	 	 	 
@("6","16","19","29","33","35"),	 	 	 
@("7","25","31","40","41","51"),	 	 	 
@("22","32","34","52","55","59"),	 	 	 
@("2","11","16","43","50","54")


)


$concurso = 1791

$conferenciafinal = @() 
$resultados = import-csv c:\temp\megasena.csv
$acertos = $null
#$resultados = $resultados[($resultados.Length -1)..$resultados.Length]
$resultados = $resultados[$resultados.Length -1]
#$resultados | ft *
#$jogo.Length

for($j = 0; $j -le ($jogo.Length-1);$J++)
{
Write-Progress -Activity "Analisando Jogos" -status "Jogo $j" -percentComplete ($j / $jogo.count*100)

foreach($rst in $resultados)
{
    $acertos = new-object PSObject
    $acertos | add-member -type NoteProperty -Name "Concurso" -Value $rst.Concurso
    $count = 0
    #write-host $rst.concurso -ForegroundColor Green
    for($i = 0; $i -le ($jogo.Length-1);$i++)
    {        
        if($jogo[$j][$i] -eq $rst.Dezena1){$count++}
        if($jogo[$j][$i] -eq $rst.Dezena2){$count++}
        if($jogo[$j][$i] -eq $rst.Dezena3){$count++}
        if($jogo[$j][$i] -eq $rst.Dezena4){$count++}
        if($jogo[$j][$i] -eq $rst.Dezena5){$count++}
        if($jogo[$j][$i] -eq $rst.Dezena6){$count++}
    }
    $acertos | add-member -type NoteProperty -Name "Jogo" -Value ($j+1)
    $acertos | add-member -type NoteProperty -Name "Acertos" -Value $count
    $conferenciafinal += $acertos
}
}

#$conferenciafinal | ?{$_.acertos -eq 4}  | Sort-Object jogo | select -Unique jogo

$conferenciafinal | ft -autosize