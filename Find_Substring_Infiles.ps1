$patern = @("poln")
Get-ChildItem -recurse -Path "\\polnwsinv01\c$\inetpub\wwwroot\" -Include *.config | Select-String -pattern $patern # | select @{l="File";e={($_.path).Substring($_.path.Length-15)}},linenumber,pattern
Get-ChildItem -recurse -Path "\\polnwsdev01\c$\inetpub\wwwroot\" -Include *.config | Select-String -pattern $patern
Get-ChildItem -recurse -Path "\\polnwshmg01\c$\inetpub\wwwroot\" -Include *.config | Select-String -pattern $patern
Get-ChildItem -recurse -Path "\\polnwsprd03\c$\inetpub\wwwroot\" -Include *.config | Select-String -pattern $patern
Get-ChildItem -recurse -Path "\\polnwsprd04\c$\inetpub\wwwroot\" -Include *.config | Select-String -pattern $patern

Get-ChildItem -recurse -Path "\\polnwsprd01\e$\tiss\" -Include *.config | Select-String -pattern $patern
Get-ChildItem -recurse -Path "\\polnwsprd01\e$\tiss2\" -Include *.config | Select-String -pattern $patern
Get-ChildItem -recurse -Path "\\polnwsprd02\e$\tiss\" -Include *.config | Select-String -pattern $patern
Get-ChildItem -recurse -Path "\\polnwsprd02\e$\tiss2\" -Include *.config | Select-String -pattern $patern


Get-ChildItem -recurse -Path "\\polndev01\c`$\inetpub\wwwroot\cooperado"