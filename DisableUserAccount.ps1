Disable-ADAccount -Identity m44059
shutdown -r -t 0 -m \\10.200.21.19


Disable-ADAccount -Identity m47740
shutdown -r -t 0 -m \\10.200.21.44



Get-ADUser -Filter {displayname -like "rodrigo*sistema*"} -Properties * | select samaccountname, displayname




Get-ADObject -filter {(name -like "*crmwebprd01*") -and (ObjectClass -eq "computer")} | Move-ADObject -TargetPath "OU=Producao,OU=Servidores,OU=Wsus - Windows Update,OU=Computadores,DC=unimedrj,DC=root"


Get-ADOrganizationalUnit -Filter 'Name -like "*tecno*"' | FT Name, DistinguishedName -A 