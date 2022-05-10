#Importar biblioteca Oracle
$LoadOracle = [Reflection.Assembly]::LoadFile("C:\app\m41718\product\11.2.0\client_1\ODP.NET\bin\2.x\Oracle.DataAccess.dll")

# Informação do BD
$DBUsername = "supwin"
$DBPassword = "unimed@2014"
$Dbs = @("//dwdbhmg01:1521/mstr","//dwdbprd02:1521/mstr","//dwdbdev01:1523/mstr")
$dbsDesc = @("Homologação","Produção","Desenvolvimento")
$saidauser = @()
$count = 0


foreach($db in $DBs){

#Write-Host
#Write-Host $dbsDesc[$count] -ForegroundColor Yellow
 
# Conectando ao Oracle
$SQLConnString = "User Id=$DBUsername;Password=$DBPassword;Data Source=$db"
$SQLConnection = New-Object Oracle.DataAccess.Client.OracleConnection($SQLConnString)
$SQLConnection.Open()

# Montando a query
$SQLQuery =  "SELECT * FROM MSTR.DSSMDOBJINFO "
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
    #$cod_usuario = $SQLReader.GetString(5)  
    #$nom_usuario = $SQLReader.GetString(4)
    #Write-Host "$cod_usuario" "`t`t|" "$nom_usuario"

  $outinfo = new-object PSObject
  $outinfo  | add-member -type NoteProperty -Name "Login" -Value $SQLReader.GetString(5) 
  $outinfo  | add-member -type NoteProperty -Name "Nome" -Value  $SQLReader.GetString(4)
  $outinfo  | add-member -type NoteProperty -Name "Ambiente" -Value  $dbsDesc[$count]
  $saidauser += $outinfo


}
#$saidauser 
$SQLConnection.Close()
$count++
}

$saidauser.Length

foreach($user in $saidauser){
try{if(Get-ADUser -Identity $user.login -ErrorAction SilentlyContinue){}
}catch{

try{if(Get-ADUser -Identity $user.login -Server adsrv33.uremh.local -ErrorAction SilentlyContinue){}}catch{ Write-Host $user.Ambiente ":" $user.login "não encontrado nos ADs (Unimedrj.root/Uremh.local)"}

}


}


