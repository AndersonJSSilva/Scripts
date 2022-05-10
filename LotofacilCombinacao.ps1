$jogo = @("1","2","4","5","6","7","9","11","17","18","19","21","23","24","25")
$naosorteados = 1..25 | % {if($_ -notin $jogo){$_} }
$A = $naosorteados[0..1] + $jogo[0..2]
$B = $naosorteados[2..3] + $jogo[3..5]
$C = $naosorteados[4..5] + $jogo[6..8]
$D = $naosorteados[6..7] + $jogo[9..11]
$E = $naosorteados[8..9] + $jogo[12..14]

$A + $B + $C
$A + $B + $D
$A + $B + $E
$A + $C + $D
$A + $C + $E
$A + $D + $E



$jogo | % {if($_ % 2 -eq 0 ){"$_ é par"}}
$jogo | % {if($_ % 2 -eq 1 ){"$_ é ímpar"}}