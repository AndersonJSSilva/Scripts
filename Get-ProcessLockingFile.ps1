$lockedFile="C:\Windows\System32\wshtcpip.dll"
Get-Process | foreach{$processVar = $_;$_.Modules | foreach{if($_.FileName -eq $lockedFile){$processVar.Name + " PID:" + $processVar.id}}}