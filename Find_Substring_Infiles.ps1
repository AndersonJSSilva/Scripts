$patern = @("neodsv","neohomolog")
Get-ChildItem -recurse -Path "\\neoctg01\d$\topsaude\web\ace\*.asp" -Include *.asp| Select-String -pattern $patern  | select @{l="File";e={($_.path).Substring($_.path.Length-15)}},linenumber,pattern


