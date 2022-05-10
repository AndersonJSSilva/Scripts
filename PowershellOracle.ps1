

Add-Type -Path "C:\app\ODP\odp.net\managed\common\Oracle.ManagedDataAccess.dll"
$username = "mstr_coop"
$password = "unimed"
$datasource = "dwdbprd02:1521/mstr"
$connectionString = 'User Id=' + $username + ';Password=' + $password + ';Data Source=' + $datasource

$query = "insert into IS_INBOX_ACT_STATS (SESSIONID,SERVERID,SERVERNAME,SERVERMACHINE,PROJECTID,INBOXACTION,USERID,USERNAME,OWNERID,OWNERNAME,MESSAGEID,MESSAGETITLE,MESSAGEDISPNAME,CREATIONTIME,STARTTIME,REPORTJOBID,DOCUMENTJOBID,SUBSCRIPTIONID,ACTIONCOMMENT,DAY_ID,HOUR_ID,MINUTE_ID,REPOSITORYID,RECORDTIME) values ('34D3BE694D37EF708DEB039B974A99D4', 'B66D839C4E557296173525972C4FF521', 'sieprd02', 'SIECOOPPRD02:34952', '949500C64F16D9A4D353BBBECC330F22', 4, '54F3D26011D2896560009A8E67019608', 'Administrator', '54F3D26011D2896560009A8E67019608', 'Administrator', 'F0DCA2264BE123F719ED4FA8758D799F', 'A01 - Book Gerencial Hospital :: Visão Entrega (NEW)', 'A01 - Book Gerencial Hospital :: Visão Entrega (NEW)', To_Date('12-07-2016 08:30:02', 'DD-MM-YYYY HH24:MI:SS'), To_Date('30-09-2016 08:30:11', 'DD-MM-YYYY HH24:MI:SS'), null, 21980, '54F3D26011D2896560009A8E67019608', '', To_Date('30-09-2016 08:30:11', 'DD-MM-YYYY HH24:MI:SS'), 2016093008, 2.0160930083E+011, '6B93E25F49DF11C5511D19A86A2B0B96',SYSDATE)" 

$connection = New-Object Oracle.ManagedDataAccess.Client.OracleConnection($connectionString)

$connection.open()
$command=$connection.CreateCommand()
$command.CommandText=$query
$saida = $command.ExecuteNonQuery()
$connection.Close()