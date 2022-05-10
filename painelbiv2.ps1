$path = 'HKCU:\Software\Microsoft\Internet Explorer\Main\'
$name = 'start page'
Set-Itemproperty -Path $path -Name $name -Value ""

[void][System.Reflection.Assembly]::LoadWithPartialName("Microsoft.VisualBasic")

add-type -AssemblyName System.Windows.Forms     
$ie = New-Object -ComObject "InternetExplorer.Application"
start-sleep -Seconds 15

$mhts = Get-ChildItem -Path \\siecoopprd02\PainelFiles$\*.mht
$i=0
foreach($file in $mhts)
{
    if($i=0)
    { 
    $file.name
    $ie.navigate("file://siecoopprd02/PainelFiles$/"+$file.name) }
    else{
    $file.name
    $ie.Navigate2("file://siecoopprd02/PainelFiles$/"+$file.name,2048)
    }
}
$i=$null

$ie.Visible = $true

start-sleep -Milliseconds 1000
$IEProcess = Get-Process | Where { $_.MainWindowHandle -eq $ie.HWND }
[Microsoft.VisualBasic.Interaction]::AppActivate($IEProcess.Id)

if($ie.fullscreen -eq $true){

}else{
    start-sleep -Seconds 5
    [System.Windows.Forms.SendKeys]::SendWait('{F11}')
}
do
{
    start-sleep -Seconds 5 
    [System.Windows.Forms.SendKeys]::SendWait('^{TAB}')
    start-sleep -Milliseconds 100
   # [System.Windows.Forms.SendKeys]::SendWait("{F5}")
}
While ($i -ne 0)