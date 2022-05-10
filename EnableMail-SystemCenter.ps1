param(
[string] $userlogin,
[string] $tipo
)
Add-PSSnapin -Name Microsoft.Exchange.Management.PowerShell.Admin

# Tipo:
# 1 -> Usuarios_A-L e Usuarios_M-Z
# 2 -> Database Coordenador
# 3 -> Database Gerente
# 4 -> Database Diretoria

try{
$user = Get-ADUser -Identity $userlogin;
}catch{ Write-Host "Usuário nao encontrado" -ForegroundColor Red;exit}

Write-Host $user.Name -ForegroundColor Cyan

if((!$tipo) -or ($tipo -notmatch "[1-4]")){write-host "Tipo nao especificado";exit}

if($tipo -eq 1 )
{
    if($user.Name.Substring(0,1) -match "[a-l]")
    {
        Write-Host Usuarios_A-L -ForegroundColor Green
        Enable-Mailbox -Identity "$userlogin@unimedrj.root" -Database "EXCBOXPRD\Usuarios_A-L\Usuarios_A-L"
        exit

    }
    else{
    
        if($user.Name.Substring(0,1) -match "[m-z]")
        {
            Write-Host Usuarios_M-Z -ForegroundColor Green
            Enable-Mailbox -Identity "$userlogin@unimedrj.root" -Database "EXCBOXPRD\Usuarios_M-Z\Usuarios_M-Z"
            exit
        }
    }
}

if($tipo -eq 2)
{
     Write-Host Coordenador -ForegroundColor Green
     Enable-Mailbox -Identity "$userlogin@unimedrj.root" -Database "EXCBOXPRD\Coordenador\Coordenador"
     exit

}
if($tipo -eq 3)
{
    Write-Host Gerente -ForegroundColor Green
    Enable-Mailbox -Identity "$userlogin@unimedrj.root" -Database "EXCBOXPRD\Gerente\Gerente"
    exit

}
if($tipo -eq 4)
{
    Write-Host Diretoria -ForegroundColor Green
    Enable-Mailbox -Identity "$userlogin@unimedrj.root" -Database "EXCBOXPRD\Diretoria\Diretoria"
    exit

}