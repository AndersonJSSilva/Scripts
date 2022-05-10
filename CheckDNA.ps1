function Restart-AppPool ($appPoolName){
$appPools = Get-WmiObject -namespace "root\MicrosoftIISv2" -class "IIsApplicationPool"  | Where-Object { $_.Name -like "W3SVC/APPPOOLS/$appPoolName" }
$appPools | %{$_.Recycle()}
}


$dna =$null
try{$dna = Invoke-WebRequest -Uri http://dna.unimedrio.com.br -UseDefaultCredentials}catch{}
if(!$dna){"Problema ao carregar o DNA";Restart-AppPool -appPoolName "dna*"}
if($dna.content | Select-String -Pattern "bem vindo" | Select-String -Pattern "bem vindo"){"DNA OK"}else{"DNA fora";Restart-AppPool -appPoolName "dna*"}
