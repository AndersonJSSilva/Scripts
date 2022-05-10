# Use shortcode to find latest TechNet download site
$confirmationPage = 'http://www.microsoft.com/en-us/download/' +  $((invoke-webrequest 'http://aka.ms/wmf5latest' -UseBasicParsing).links | ? Class -eq 'mscom-link download-button dl' | % href)
# Parse confirmation page and look for URL to file
$directURL = (invoke-webrequest $confirmationPage -UseBasicParsing).Links | ? Class -eq 'mscom-link' | ? href -match 'Win8.1AndW2K12R2' | % href | select -first 1
# Download file to local
$filename = "C:\Users\m41718\Downloads\"+($directURL -split "/")[($directURL -split "/").Length-1]
$download = invoke-webrequest $directURL -OutFile $filename
# Install quietly with no reboot
if (test-path $env:Temp\wmf5latest.msu) {
  start -wait $env:Temp\wmf5latest.msu -argumentlist '/quiet /norestart'
  }
else { throw 'the update file is not available at the specified location' }
# Clean up
Remove-Item $env:Temp\wmf5latest.msu

# Assumption is that the next likely step will be DSC config, starting with xPendingReboot to finish install

<#
File names:
W2K12-KB3134759-x64.msu
Win7AndW2K8R2-KB3134760-x64.msu
Win7-KB3134760-x86.msu
Win8.1AndW2K12R2-KB3134758-x64.msu
Win8.1-KB3134758-x86.msu
#>