## The URI list to test 
$URLList =  @("http://portaldocolaborador/corpore.net")  
$Result = @() 
   
   
Foreach($Uri in $URLList) { 
$time = try{ 
    $request = $null 
    $result1 = Measure-Command { $request = Invoke-WebRequest -Uri $uri } 
    $result1.TotalMilliseconds 
}  
catch 
{ 
   $request = $_.Exception.Response 
   $time = -1 
  }   
  $result += [PSCustomObject] @{ 
  Time = Get-Date; 
  Uri = $uri; 
  StatusCode = [int] $request.StatusCode; 
  StatusDescription = $request.StatusDescription; 
  ResponseLength = $request.RawContentLength; 
  TimeTaken =  $time;  
  } 
 
} 

 
if($result -ne $null) 
{ 
    $Outputreport = "<HTML><TITLE>Website Availability Report</TITLE><BODY background-color:peachpuff><font color =""#99000"" face=""Microsoft Tai le""><H2> Website Availability Report </H2></font><Table border=1 cellpadding=0 cellspacing=0><TR bgcolor=gray align=center><TD><B>URL</B></TD><TD><B>StatusCode</B></TD><TD><B>StatusDescription</B></TD><TD><B>ResponseLength</B></TD><TD><B>TimeTaken</B></TD</TR>" 
    Foreach($Entry in $Result) 
    { 
        if($Entry.StatusCode -ne "200") 
        { 
            $Outputreport += "<TR bgcolor=red>" 
        } 
        else 
        { 
            $Outputreport += "<TR>" 
        } 
        $Outputreport += "<TD>$($Entry.uri)</TD><TD align=center>$($Entry.StatusCode)</TD><TD align=center>$($Entry.StatusDescription)</TD><TD align=center>$($Entry.ResponseLength)</TD><TD align=center>$($Entry.timetaken)</TD></TR>" 
    } 
    $Outputreport += "</Table></BODY></HTML>" 
} 
 
$Outputreport | out-file C:\Scripts\Test.htm 
Invoke-Expression C:\Scripts\Test.htm  

if(($request.StatusCode -ne "200") -or ($request.RawContentLength -ne "15049"))
{

    Restart-service -ComputerName excprd04 -Servicename rm.host.service
    Restart-service -ComputerName excprd04 -Servicename w3svc

}