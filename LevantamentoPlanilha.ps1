$computers = Get-ADComputer -Filter {OperatingSystem -Like "Windows Server*"} -Property *
$computers.count
$saida = @()



foreach($srv in $computers)
{

$computername = $srv.Name
try{
if(Test-Connection -Count 1 -ComputerName $computername -ErrorAction Stop)
{

$computersystem = Get-WmiObject -Class Win32_ComputerSystem -ComputerName $computername | select *
$operatingsystem = Get-WmiObject Win32_OperatingSystem -ComputerName $computername | select *
$processor = Get-WmiObject Win32_Processor -ComputerName $computername | select *
$PhysicalMemory = Get-WmiObject CIM_PhysicalMemory -ComputerName $computername | Measure-Object -Property capacity -Sum | % {[math]::round(($_.sum / 1GB),2)} 
$hdd = gwmi win32_logicaldisk -Computername $computername |? {$_.drivetype -eq 3}


$ambiente = ""
if($srv.Name -like "*prd*"){$ambiente="producao"}
if($srv.Name -like "*hmg*"){$ambiente="homologacao"}
if($srv.Name -like "*inv*"){$ambiente="investigacao"}
if($srv.Name -like "*dev*" -or $srv.Name -like "*dsv*"){$ambiente="desenvolvimento"}

[string]$hddsize = ""
$sizes = ($hdd | %{[math]::Round($_.Size/1GB,0)})
[string]$hddsize += $sizes | %{$_}

$server = new-object PSObject
$server | add-member -type NoteProperty -Name "Plataforma" -Value $computersystem.Model
$server | add-member -type NoteProperty -Name "Tipo" -Value ""
$server | add-member -type NoteProperty -Name "Item_configuracao" -Value $srv.Name
$server | add-member -type NoteProperty -Name "Ambiente" -Value $ambiente
$server | add-member -type NoteProperty -Name "Localizacao" -Value ""
$server | add-member -type NoteProperty -Name "BancodeDados" -Value ""
$server | add-member -type NoteProperty -Name "Versao" -Value ""
$server | add-member -type NoteProperty -Name "ClusterBD" -Value ""
$server | add-member -type NoteProperty -Name "SO" -Value $operatingsystem.Caption
$server | add-member -type NoteProperty -Name "ServicePackVersion" -value $operatingsystem.ServicePackMajorVersion
$server | add-member -type NoteProperty -Name "CPU" -value $processor[0].Name
$server | add-member -type NoteProperty -Name "CoresQTD" -Value ($processor.NumberOfCores | Measure-Object -Sum | select sum).sum
$server | add-member -type NoteProperty -Name "Memoria" -Value $PhysicalMemory
$server | add-member -type NoteProperty -Name "HD" -Value $hddsize

$saida += $server 

$server | ft Item_configuracao

}
else{Write-Host $srv.Name OFFLINE -BackgroundColor Red}
}catch{Write-Host $srv.Name NAO ENCONTRADO -BackgroundColor Red}


}


$saida | export-csv -Delimiter ";" -Encoding Unicode -Path \\10.200.5.57\c$\levantamento.csv