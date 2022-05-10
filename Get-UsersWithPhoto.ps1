Get-ADUser -Filter 'thumbnailPhoto -like "*"' | Select name | Sort-Object 'Name'
