#Importar biblioteca Oracle
$LoadOracle = [Reflection.Assembly]::LoadFile("C:\app\m41718\product\11.2.0\client_1\ODP.NET\bin\2.x\Oracle.DataAccess.dll")

# Informação do BD
$DBUsername = "supwin"
$DBPassword = "unimed@2014"
$Dbs = @("//dwdbhmg01:1521/mstr","//10.100.2.57:1521/mstr","//dwdbdev01:1523/mstr")
$dbsDesc = @("Homologação","Produção","Desenvolvimento") 
$UsersHMG = @()
$UsersPRD = @()
$UsersDEV = @()
$UsersUREH = @()
$count = 0
#$db = "//10.100.2.57:1521/mstr"

foreach($db in $DBs){

Write-Host
Write-Host $dbsDesc[$count] -ForegroundColor Yellow
 
# Conectando ao Oracle
$SQLConnString = "User Id=$DBUsername;Password=$DBPassword;Data Source=$db"
$SQLConnection = New-Object Oracle.DataAccess.Client.OracleConnection($SQLConnString)
$SQLConnection.Open()

# Montando a query
$SQLQuery =  "SELECT * FROM MSTR.MU_DSSMDOBJINFO "
$SQLQuery += "WHERE OBJECT_TYPE = 34 AND SUBTYPE = 8704"

#Write-Host $SQLQuery

#Executando a query
try
{
    $SQLCommand = New-Object Oracle.DataAccess.Client.OracleCommand($SQLQuery,$SQLConnection)
    $SQLReader = $SQLCommand.ExecuteReader()
}
catch
{
    Write-Host $_
}

<# Exibe a estrutura do result set 
for ($i=0;$i -lt $SQLReader.FieldCount;$i++)
{
    Write-Host  $SQLReader.GetName($i) $SQLReader.GetDataTypeName($i) 
}#>

# Exibindo os resultados para as 2 primeiras colunas 
while ($SQLReader.read())
{
    $cod_usuario = $SQLReader.GetString(5)  
    $nom_usuario = $SQLReader.GetString(4)
    Write-Host "$cod_usuario" "`t|" "$nom_usuario"
}
$SQLConnection.Close()
$count++
}



$users = Get-Content -Path C:\temp\matriculaneo.txt
$users.Length
$usersfound = @()
$usersnotfound = @()
foreach($user in $users)
{
   try{
        $usrtmp = Get-ADUser -Server dcbenprd06.unimedrj.root -identity $user -properties * -ErrorAction SilentlyContinue
        $usersfound += $usrtmp
        if( $usrtmp.Enabled)
        {  Write-Host $usrtmp.SamAccountName $usrtmp.Department -ForegroundColor Yellow }
        else
        {  Write-Host $usrtmp.SamAccountName $usrtmp.Department -ForegroundColor Red   }
   }
   catch
   {
        write-host $user Não encontrado -foregroundColor Cyan
        $usersnotfound += $usrtmp     
   }
}
$usersfound.Length
$usersnotfound.Length


$QUERY = @()
FOREACH($usrtmp in $usersfound)
{
    $department = $usrtmp.Department
    $sam = ($usrtmp.SamAccountName).ToUpper()
    $QUERY += "UPDATE TS.USUARIO SET TXT_LOCAL_USUARIO = '$department' WHERE COD_USUARIO = '$sam';"

}
Set-Content -Path c:\temp\saidaneo.txt $query


# UPDATE TS.USUARIO SET TXT_LOCAL_USUARIO = '' WHERE COD_USUARIO = ''
