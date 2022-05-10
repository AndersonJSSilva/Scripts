param($eventid)

function InsertSQL-EventLog($log, $data){
$conn = New-Object System.Data.SqlClient.SqlConnection
$conn.ConnectionString = "Data Source=sql2008hmg01;Initial Catalog=eventlog_ad;Integrated Security=true;"
$conn.open()
$cmd = New-Object System.Data.SqlClient.SqlCommand
$cmd.connection = $conn
$cmd.commandtext = "INSERT INTO Event (hostName,Message,Event_Id,Time_generated)VALUES('{0}','{1}','{2}',convert(datetime,'{3}',103))" -f $log.ComputerName,$log.Message,$log.EventCode,$data
$cmd.executenonquery()
$conn.close()
}
function sendMail($subject, $body ){

     #SMTP server name
     $smtpServer = “mail.unimedrio.com.br”
     #Creating a Mail object
     $msg = new-object Net.Mail.MailMessage
     #Creating SMTP server object
     $smtp = new-object Net.Mail.SmtpClient($smtpServer)
     #Email structure 
     $msg.From = “eventlogmon@unimedrio.com.br“
     $msg.ReplyTo = “eventlog.audit@unimedrio.com.br“
     $msg.To.Add(“eventlog.audit@unimedrio.com.br“)
     $msg.subject = $subject
     $msg.body = $body
     #Sending email 
     $smtp.Send($msg)
  
}

$eventcodes = @($eventid)

$time = [System.Management.ManagementDateTimeConverter]::ToDmtfDateTime((Get-Date).AddSeconds(-4))
$logs = Get-WmiObject Win32_NTLogEvent -filter "LogFile='Security' and TimeGenerated>='$time'"

foreach($log in $logs)
{
    foreach($code in $eventcodes)
    {
        if($log.EventCode -eq $code )
        {
            #$log.PSComputerName
            #$log.Message
            #$log.EventCode
            $data = (get-date([System.Management.ManagementDateTimeConverter]::ToDateTime($log.TimeGenerated)) -Format "dd/MM/yyyy hh:mm:ss").ToString()
            sendMail -subject ("Event "+ $log.EventCode + " " +$data) -body ($log.ComputerName+"`n`n"+$log.Message)
            #InsertSQL-EventLog -log $log -data $data
        }        
    }
}

exit



