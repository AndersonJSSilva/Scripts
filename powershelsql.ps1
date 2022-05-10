#$c = Get-Credential
#Write-Host $c.username 
#Write-Host $c.GetNetworkCredential().password
$hostsql = Read-Host "Qual o servidor?"
$database = Read-Host "Qual database?"
$usersql = "sa" # Read-Host "Qual o usuario?"
$passwordsql = Read-Host "Qual senha?"
$connectionString = "server="+$hostsql+";database="+$database+";uid="+$usersql+";pwd="+$passwordsql+";"

Write-Host $hostsql
Write-Host $database
write-host $connectionString
Write-host $usersql
Write-host $passwordsql
[Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR($passwordsql))
$conn = New-Object system.Data.SqlClient.SqlConnection
$conn.connectionstring = $connectionString
$conn.open()
switch ($conn.State)
{
"Open" { Write-Host "Do some work"; }
Default { Write-Host "The connection is $($conn.State).  There has been an error connecting to the database."; }
}
