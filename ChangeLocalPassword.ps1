$computers = @("lmsprd01")

$computers = Get-Content C:\temp\onda6.txt

$password = Read-Host "Digite a nova senha" -AsSecureString
$confirmpassword = Read-Host "Repita a nova senha" -AsSecureString
$pwd1_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($password))
$pwd2_text = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($confirmpassword))
if($pwd1_text -ne $pwd2_text) {
   Write-Error "As senhas estão diferentes. Encerrando script"
exit
}

foreach ($Computer in $Computers) {
   $Computer    =    $Computer.toupper()
   $Isonline    =    "OFFLINE"
   $Status        =    "SUCCESS"
    Write-Verbose "Trabalhando em $Computer"
if((Test-Connection -ComputerName $Computer -count 1 -ErrorAction 0)) {
   $Isonline = "ONLINE"
   Write-Verbose "`t$Computer está Online"
} else { Write-Verbose "`t$Computer está OFFLINE" }
 
try {
   $account = [ADSI]("WinNT://$Computer/Administrator,user")
   $account.psbase.invoke("setpassword",$pwd1_text)
   Write-Verbose "`tSenha trocada com sucesso"
}
catch {
  $status = "FAILED"
  Write-Verbose "`tFalha ao trocar a senha do administrator . Erro: $_"
}
 
$obj = New-Object -TypeName PSObject -Property @{
  ComputerName = $Computer
  IsOnline = $Isonline
  PasswordChangeStatus = $Status
}
 
$obj | Select ComputerName, IsOnline, PasswordChangeStatus
 
if($Status -eq "FAILED" -or $Isonline -eq "OFFLINE") {
   $stream.writeline("$Computer `t $isonline `t $status")
}
 
}