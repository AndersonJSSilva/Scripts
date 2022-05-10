#Importar biblioteca Oracle x86
$LoadOracle = [Reflection.Assembly]::LoadFile("C:\app\Administrador\product\11.2.0\client_1\ODP.NET\bin\2.x\Oracle.DataAccess.dll")

# Informação do BD
$DBUsername = "rm"
$DBPassword = "rm"
$db = @("//oradbhmg01:1521/rmhmg")

# Conectando ao Oracle
$SQLConnString = "User Id=$DBUsername;Password=$DBPassword;Data Source=$db"
$SQLConnection = New-Object Oracle.DataAccess.Client.OracleConnection($SQLConnString)
$SQLConnection.Open()

<# Montando a query
$SQLQuery ="SELECT

A.CHAPA AS Matricula,
A.NOME AS Nome_do_usuario,
B.DESCRICAO AS Status,
A.DATAADMISSAO AS Data_da_Admissao,
A.DATADEMISSAO as Data_da_Demissao,
C.NOME AS Cargo,
D.DESCRICAO AS area,
D.BAIRRO AS Localidade

FROM PFUNC A LEFT OUTER JOIN PCODSITUACAO B ON A.CODSITUACAO = B.CODINTERNO
             LEFT OUTER JOIN PFUNCAO C ON A.CODFUNCAO = C.CODIGO AND A.CODCOLIGADA = C.CODCOLIGADA
             LEFT OUTER JOIN PSECAO D ON A.CODSECAO = D.CODIGO AND A.CODCOLIGADA = D.CODCOLIGADA

WHERE B.DESCRICAO = 'Ativo'"
#>

$SQLQuery = "
SELECT DISTINCT

D.NOMEFANTASIA AS EMPRESA,
A.CHAPA,
A.NOME,
C.NOME AS CARGO,
B.DESCRICAO AS AREA,
( SELECT CASE WHEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,17)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA ) IS NOT NULL 
              THEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,17)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA )
              WHEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,15)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA ) IS NOT NULL
              THEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,15)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA )
              WHEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,13)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA ) IS NOT NULL
              THEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,13)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA )
              WHEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,11)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA ) IS NOT NULL
              THEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,11)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA )
              WHEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,7)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA ) IS NOT NULL
              THEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,7)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA )
              WHEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,6)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA ) IS NOT NULL
              THEN ( SELECT B1.NOME FROM PFUNC B1 LEFT OUTER JOIN PSUBSTCHEFE A1 ON B1.CHAPA = A1.CHAPASUBST AND B1.CODCOLIGADA = A1.CODCOLIGADA WHERE SUBSTR(A.CODSECAO,1,6)=A1.CODSECAO AND A1.CODCOLIGADA = A.CODCOLIGADA )
              
              ELSE 'SEM CHEFE CADASTRADO'
              END FROM DUAL) AS GESTOR,
D.BAIRRO AS LOCALIDADE

FROM PFUNC A LEFT OUTER JOIN PSECAO B ON A.CODSECAO = B.CODIGO AND A.CODCOLIGADA = B.CODCOLIGADA
             LEFT OUTER JOIN PFUNCAO C ON A.CODFUNCAO = C.CODIGO AND A.CODCOLIGADA  = C.CODCOLIGADA
             LEFT OUTER JOIN GCOLIGADA D ON A.CODCOLIGADA = D.CODCOLIGADA      
             
             
WHERE A.CODSITUACAO <> 'D' AND
      A.CODTIPO NOT IN ('A','C')
   
      
ORDER BY 1
"

#Executando a query
try{
    $SQLCommand = New-Object Oracle.DataAccess.Client.OracleCommand($SQLQuery,$SQLConnection)
    $SQLReader = $SQLCommand.ExecuteReader()
}catch{Write-Host $_}

#Exibe a estrutura do result set 
for ($i=0;$i -lt $SQLReader.FieldCount;$i++){Write-Host  $SQLReader.GetName($i) $SQLReader.GetDataTypeName($i)}

$saidarm = @()
while ($SQLReader.read())
{
     $user_rm = new-object PSObject
     $user_rm  | add-member -type NoteProperty -Name "empresa" -Value $SQLReader.GetString(0)
     $user_rm  | add-member -type NoteProperty -Name "chapa" -Value $SQLReader.GetString(1)
     $user_rm  | add-member -type NoteProperty -Name "nome" -Value $SQLReader.GetString(2)
     $user_rm  | add-member -type NoteProperty -Name "cargo" -Value $SQLReader.Getstring(3)
     $user_rm  | add-member -type NoteProperty -Name "area" -Value $SQLReader.GetString(4)
     $user_rm  | add-member -type NoteProperty -Name "gestor" -Value $SQLReader.GetString(5)
     $user_rm  | add-member -type NoteProperty -Name "localidade" -Value $SQLReader.GetString(6)
     $user_rm  | add-member -type NoteProperty -Name "email" -Value $null
     #$user_rm 
     $saidarm += $user_rm

}
$SQLConnection.Close()
$saidarm.Count


$usersCOOP = @()
$usersUREMH = @()
$usersCEFIS = @()
foreach($u in $saidarm)
{

    if($u.empresa -eq "UNIMED-RIO")
    {
        $usersCOOP += $u
    }else
    { 
        if($u.empresa -eq "UNIMED-RIO EMPREENDIMENTOS MEDICOS E HOSPITALARES LTDA")
        {
            $usersUREMH += $u
        }
        else
        {
            if($u.empresa -eq "CEFIS - CENTRO DE EXCELENCIA FISICA UNIMED-RIO E FJG LTDA")
            {
                $usersCEFIS += $u
            }
        }    
    }
}
$usersCOOP.count
$usersUREMH.count
$usersCEFIS.count

$gestorCooptmp = $usersCOOP | select gestor -Unique
$gestorCooptmp.count
$gestorCoop = @()
foreach($g in $gestorCooptmp)
{
    foreach($user in $usersCOOP)
    {
        if($user.nome -eq $g.gestor)
        {
            $gestorCoop += $user
        }
    }
}
$gestorCoop.Count

$usersCOOPcomemail = @()
foreach($user in $usersCOOP)
{
    if($user.cargo.StartsWith("JOVEM"))
    {
        $user.nome
        try{$user.email = (Get-ADUser -Identity ("ja"+$user.chapa.TrimStart("0"))-Properties mail -ErrorAction SilentlyContinue).mail}catch{Write-Host não econtrado -ForegroundColor Red}
        $usersCOOPcomemail += $user
    }else{

        if($user.cargo.StartsWith("ESTAGIARIO"))
        {
            $user.nome
            try{$user.email = (Get-ADUser -Identity ("est"+$user.chapa.TrimStart("0"))-Properties mail -ErrorAction SilentlyContinue).mail}catch{Write-Host não econtrado -ForegroundColor Red}
            $usersCOOPcomemail += $user
        }else
        {
            if($user.chapa.StartsWith("E"))
            {
                $user.nome
                try{$user.email = (Get-ADUser -Identity ("e"+($user.chapa.TrimStart("E")).TrimStart("0")) -Properties mail -ErrorAction SilentlyContinue).mail}catch{Write-Host não econtrado -ForegroundColor Red}
                $usersCOOPcomemail += $user

            }else
            {
                $user.nome
                try{$user.email = (Get-ADUser -Identity ("m"+$user.chapa.TrimStart("0")) -Properties mail -ErrorAction SilentlyContinue).mail}catch{Write-Host não econtrado -ForegroundColor Red}
                $usersCOOPcomemail += $user
            }
        }
    }
}
$usersCOOPcomemail.Count
($usersCOOPcomemail |?{$_.email -eq $null}).count


$usersCOOPcomemail | %{Write-Host UPDATE usuario SET area = $_.area',' cargo = $_.cargo WHERE chapa = $_.chapa';'}





