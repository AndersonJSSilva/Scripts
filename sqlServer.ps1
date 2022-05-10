$hostsql = Read-Host "Qual o servidor?"
$database = Read-Host "Qual database?"
$usersql = Read-Host "Qual o usuario?"
$passwordsql = Read-Host "Qual senha?"

$connectionString = "server="+$hostsql+";database="+$database+";uid="+$usersql+";pwd="+$passwordsql+";"

$SqlConnection = New-Object system.Data.SqlClient.SqlConnection
$SqlConnection.connectionstring = $connectionString
$SqlConnection.Open()

# Abrindo conexao com o servidor de BD
$SqlCmd = New-Object System.Data.SqlClient.SqlCommand
$SqlCmd.Connection = $SqlConnection
$SqlCmd.CommandTimeout = 0
if ($SqlConnection.State -ne "Open")
{
    Write-host "Abrindo conexao com o servido de BD"
    $SqlCmd.Connection.Open()
}
else
{
    Write-Host "Status de conexao com o servidor: "$SqlConnection.State
}

# Executando a query e buscado o resultado
$SqlCmd.CommandText = "select * from TABLE"
$SqlAdapter = New-Object System.Data.SqlClient.SqlDataAdapter
$SqlAdapter.SelectCommand = $SqlCmd
$DataSet = New-Object System.Data.DataSet
$SqlAdapter.Fill($DataSet)
$DataSet.Tables[0] > c:\result.txt

$SqlAdapter.UpdateCommand

if ($SqlConnection.State -eq "Open")
{
    Write-host "Fechando conexao com o servido de BD"
    $SqlConnection.Close()
}