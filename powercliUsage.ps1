Get-VM | Where {$_.PowerState -eq "PoweredOn"} | Select Name, Host, NumCpu, MemoryMB, `
@{N="CPU Usage (Average), Mhz" ; E={[Math]::Round((($_ | Get-Stat -Stat cpu.usagemhz.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}}, `
@{N="Memory Usage (Average), %" ; E={[Math]::Round((($_ | Get-Stat -Stat mem.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} , `
@{N="Network Usage (Average), KBps" ; E={[Math]::Round((($_ | Get-Stat -Stat net.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} , `
@{N="Disk Usage (Average), KBps" ; E={[Math]::Round((($_ | Get-Stat -Stat disk.usage.average -Start (Get-Date).AddDays(-30) -IntervalMins 5 | Measure-Object Value -Average).Average),2)}} |`
Export-Csv -Path c:\temp\AverageUsageVMs.csv -Encoding Unicode