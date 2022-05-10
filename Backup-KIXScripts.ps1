set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"  
$data = (get-date -Format yyyyMMdd).ToString()
$Source = "\\unimedrj\netlogon\scripts\" 
$Target = "C:\temp\BKP_KIX\scripts_"+$data+".zip"
sz a -mx=9 $Target $Source