$from = "helpdesk-naoresponda@unimedrio.com.br"
$to = "carlosrafaeldavid@gmail.com"
$cc = "carlosrafaeldavid@gmail.com"
$assunto = "Teste de envio - Unimed Rio - Relay Externo 2 "
$corpo = "`n`nteste de emai"

Send-MailMessage -to $to -from $from -Cc $cc -subject $assunto -SmtpServer "10.100.1.133" -Body $corpo


