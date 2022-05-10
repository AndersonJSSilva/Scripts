$conferenciafinal = @()    
$resultados = import-csv c:\temp\lotofacil.csv
#$resultados = $resultados[1200..1202]
#$resultados | ft *
$jogo = @("2","3","4","7","9","11","12","15","17","18","19","21","22","23","25")
$acertos = $null
foreach($rst in $resultados)
{
    $acertos = new-object PSObject
    $acertos | add-member -type NoteProperty -Name "Concurso" -Value $rst.Concurso
    $count = 0
    #write-host $rst.concurso -ForegroundColor Green
    for($i = 0; $i -le 16;$i++)
    {        
        if($jogo[$i] -eq $rst.Bola1){$count++}if($jogo[$i] -eq $rst.Bola2){$count++}if($jogo[$i] -eq $rst.Bola3){$count++}if($jogo[$i] -eq $rst.Bola4){$count++}if($jogo[$i] -eq $rst.Bola5){$count++}if($jogo[$i] -eq $rst.Bola6){$count++}
        if($jogo[$i] -eq $rst.Bola7){$count++}if($jogo[$i] -eq $rst.Bola8){$count++}if($jogo[$i] -eq $rst.Bola9){$count++}if($jogo[$i] -eq $rst.Bola10){$count++}if($jogo[$i] -eq $rst.Bola11){$count++}if($jogo[$i] -eq $rst.Bola12){$count++}
        if($jogo[$i] -eq $rst.Bola13){$count++}if($jogo[$i] -eq $rst.Bola14){$count++}if($jogo[$i] -eq $rst.Bola15){$count++}

    }
    $acertos | add-member -type NoteProperty -Name "Acertos" -Value $count
    $conferenciafinal += $acertos

}
$conferenciafinal | ?{$_.acertos -gt 12} | ft * -AutoSize

$conferenciafinal |ft * -AutoSize