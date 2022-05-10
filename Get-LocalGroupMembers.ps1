#$listofIPs = Get-Content c:\temp\servers.txt
$scope = read-host "digite o escopo"
if(!$scope)
{
    break
}

$a = (netsh dhcp server 10.100.1.50 scope $scope show clients 1)
$DHCPResult = @()
foreach ($i in $a)
{
    try{
        if($i.substring(0,2) -eq "10")
        {
            $DHCPResult  += ($i.substring(0,12)).Trim()
        }
    } catch {}
}
$DHCPResult = "unibar03039001"
<#
$ResultList = @()
foreach ($ip in $DHCPResult)
{
     $result = $null    
     $currentEAP = $ErrorActionPreference
     try {
        $result = [System.Net.Dns]::gethostentry($ip)
     } catch {
        #write-host "Host nao encontrado: " $ip
     }
     $ErrorActionPreference = $currentEAP
     If ($Result)
     {
          $a = ([string]$Result.HostName).Replace(".unimedrj.root", "")
          Write-Host "$a - Encontrado"
          $Resultlist += $a
     }
     Else
     {
          write-host "$IP - HostName nao encontrado"
     }
}
#$ResultList#>

$OutputFile = Join-Path $OutputDir "LocalGroupMembers.csv"
Write-Verbose "Script will write the output to $OutputFile folder"
Add-Content -Path $OutPutFile -Value "ComputerName, LocalGroupName, Status, MemberType, MemberDomain, MemberName"

ForEach($Computer in $DHCPResult) {
		Write-host "Verificando - $Computer"
		If(!(Test-Connection -ComputerName $Computer -Count 1 -Quiet)) {
			Write-Verbose "$Computer is offline. Proceeding with next computer"
			Add-Content -Path $OutputFile -Value "$Computer,$LocalGroupName,Offline"
			Continue
		} else {
			Write-Verbose "Verificando - $computer"
			try {
				$group = [ADSI]"WinNT://$Computer/$LocalGroupName"
				$members = @($group.Invoke("Members"))
				Write-Verbose "Query executada com sucesso para $computer"
				if(!$members) {
					Add-Content -Path $OutputFile -Value "$Computer,$LocalGroupName,NoMembersFound"
					Write-Verbose "Nenhum membro encontrado"
					continue
				}
			}		
			catch {
				Write-Verbose "Falha em pesquisar os membros em $computer"
				Add-Content -Path $OutputFile -Value "$Computer,,FalhaAOpesquisar"
				Continue
			}
			foreach($member in $members) {
				try {
					$MemberName = $member.GetType().Invokemember("Name","GetProperty",$null,$member,$null)
					$MemberType = $member.GetType().Invokemember("Class","GetProperty",$null,$member,$null)
					$MemberPath = $member.GetType().Invokemember("ADSPath","GetProperty",$null,$member,$null)
					$MemberDomain = $null
					if($MemberPath -match "^Winnt\:\/\/(?<domainName>\S+)\/(?<CompName>\S+)\/") {
						if($MemberType -eq "User") {
							$MemberType = "LocalUser"
						} elseif($MemberType -eq "Group"){
							$MemberType = "LocalGroup"
						}
						$MemberDomain = $matches["CompName"]

					} elseif($MemberPath -match "^WinNT\:\/\/(?<domainname>\S+)/") {
						if($MemberType -eq "User") {
							$MemberType = "DomainUser"
						} elseif($MemberType -eq "Group"){
							$MemberType = "DomainGroup"
						}
						$MemberDomain = $matches["domainname"]

					} else {
						$MemberType = "Unknown"
						$MemberDomain = "Unknown"
					}
				 
                if(($MemberName -ne "Administrador") -and ($MemberName -ne "Domain Admins") -and ($MemberName -ne "_DeskAdmin") -and ($MemberDomain -ne "Unknown") )
                {
                    Add-Content -Path $OutPutFile -Value "$Computer, $LocalGroupName, Sucesso, $MemberType, $MemberDomain, $MemberName"
                }
				} catch {
					Write-Verbose "failed to query details of a member. Details $_"
					Add-Content -Path $OutputFile -Value "$Computer,,FailedQueryMember"
				}

			} 
		}

}
