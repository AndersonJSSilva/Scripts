EmailAddressPolicyEnabled $false.


Measure-Command -Expression { Get-WmiObject -Query 'select Version from Win32_OperatingSystem WHERE (Version like "6.%" OR version like "10.%") AND ProductType="1"'}


Get-WmiObject -Query 'Select * From Win32_ComputerSystem where Name = "unicoop30924"'

Get-WmiObject -Query 'SELECT * FROM Win32_IP4RouteTable where Caption LIKE "10.200.5.%"'

Get-WmiObject -Query 'SELECT * FROM Win32_IP4RouteTable where Caption = "10.200.5.57" OR Caption = "10.200.5.50" OR Caption = "10.200.5.94"'



Measure-Command -Expression { Get-WmiObject -Query 'select name from Win32_Product where name like "%Google Chrome%"'}
Measure-Command -Expression { Get-WmiObject -Query  'select * from Win32_SoftwareElement where name like "%Chrome%"'}

Select * From Win32_ComputerSystem where Name LIKE "unicoop%"


On Mondays:

select DayOfWeek from Win32_LocalTime where DayOfWeek = 1

On the weekend:

select DayOfWeek from Win32_LocalTime where DayOfWeek > 5

During the work Week:

select DayOfWeek from Win32_LocalTime where DayOfWeek < 6

Any Windows Desktop OS

select * from Win32_OperatingSystem WHERE (ProductType <> "2") AND (ProductType <> "3")

Any Windows Desktop OS - 32-bit

select * from Win32_OperatingSystem WHERE ProductType = "1" AND NOT OSArchitecture = "64-bit"

Any Windows Desktop OS - 64-bit

select * from Win32_OperatingSystem WHERE ProductType = "1" AND OSArchitecture = "64-bit"

Windows XP

select * from Win32_OperatingSystem WHERE (Version like "5.1%" or Version like "5.2%") AND ProductType="1"

Windows XP - 32-bit

select * from Win32_OperatingSystem WHERE (Version like "5.1%" or Version like "5.2%") AND ProductType="1" AND NOT OSArchitecture = "64-bit"

Windows XP - 64-bit

select * from Win32_OperatingSystem WHERE (Version like "5.1%" or Version like "5.2%") AND ProductType="1" AND OSArchitecture = "64-bit"

Windows Vista

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="1"

Windows Vista - 32-bit

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="1" AND NOT OSArchitecture = "64-bit"

Windows Vista - 64-bit

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="1" AND OSArchitecture = "64-bit"

Windows 7

select * from Win32_OperatingSystem WHERE Version like "6.1%" AND ProductType="1"

Windows 7 - 32-bit

select * from Win32_OperatingSystem WHERE Version like "6.1%" AND ProductType="1" AND NOT OSArchitecture = "64-bit"

Windows 7 - 64-bit

select * from Win32_OperatingSystem WHERE Version like "6.1%" AND ProductType="1" AND OSArchitecture = "64-bit"

Windows 8

select * from Win32_OperatingSystem WHERE Version like "6.2%" AND ProductType="1"

Windows 8 - 32-bit

select * from Win32_OperatingSystem WHERE Version like "6.2%" AND ProductType="1" AND NOT OSArchitecture = "64-bit"

Windows 8 - 64-bit

select * from Win32_OperatingSystem WHERE Version like "6.2%" AND ProductType="1" AND OSArchitecture = "64-bit"

Windows 8.1

select * from Win32_OperatingSystem WHERE Version like "6.3%" AND ProductType="1"

Windows 8.1 - 32-bit

select * from Win32_OperatingSystem WHERE Version like "6.3%" AND ProductType="1" AND NOT OSArchitecture = "64-bit"

Windows 8.1 - 64-bit

select * from Win32_OperatingSystem WHERE Version like "6.3%" AND ProductType="1" AND OSArchitecture = "64-bit"

Windows 10

select * from Win32_OperatingSystem WHERE Version like "10.%" AND ProductType="1"

Windows 10 - 32-bit

select * from Win32_OperatingSystem WHERE Version like "10.%" AND ProductType="1" AND NOT OSArchitecture = "64-bit"

Windows 10 - 64-bit

select * from Win32_OperatingSystem WHERE Version like "10.%" AND ProductType="1" AND OSArchitecture = "64-Bit"

Microsoft Windows Servers

 

Any Windows Server OS

select * from Win32_OperatingSystem where (ProductType = "2") OR (ProductType = "3")

Any Windows Server OS - 32-bit

select * from Win32_OperatingSystem where (ProductType = "2") OR (ProductType = "3") AND NOT OSArchitecture = "64-bit"

Any Windows Server OS - 64-bit

select * from Win32_OperatingSystem where (ProductType = "2") OR (ProductType = "3") AND OSArchitecture = "64-bit"

Any Windows Server - Domain Controller

select * from Win32_OperatingSystem where (ProductType = "2")

Any Windows Server - Domain Controller - 32-bit

select * from Win32_OperatingSystem where (ProductType = "2") AND NOT OSArchitecture = "64-bit"

Any Windows Server - Domain Controller - 64-bit

select * from Win32_OperatingSystem where (ProductType = "2") AND OSArchitecture = "64-bit"

Any Windows Server - Non-Domain Controller

select * from Win32_OperatingSystem where (ProductType = "3")

Any Windows Server - Non- Domain Controller - 32-bit

select * from Win32_OperatingSystem where (ProductType = "3") AND NOT OSArchitecture = "64-bit"

Any Windows Server - Non-Domain Controller - 64-bit

select * from Win32_OperatingSystem where (ProductType = "3") AND OSArchitecture = "64-bit"

Windows Server 2003 - DC

select * from Win32_OperatingSystem WHERE Version like "5.2%" AND ProductType="2"

Windows Server 2003 - non-DC

select * from Win32_OperatingSystem WHERE Version like "5.2%" AND ProductType="3"

Windows Server 2003 - 32-bit - DC

select * from Win32_OperatingSystem WHERE Version like "5.2%" AND ProductType="2" AND NOT OSArchitecture = "64-bit"

Windows Server 2003 - 32-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "5.2%" AND ProductType="3" AND NOT OSArchitecture = "64-bit"

Windows Server 2003 - 64-bit - DC

select * from Win32_OperatingSystem WHERE Version like "5.2%" AND ProductType="2" AND OSArchitecture = "64-bit"

Windows Server 2003 - 64-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "5.2%" AND ProductType="3" AND OSArchitecture = "64-bit"

Windows Server 2003 R2 - DC

select * from Win32_OperatingSystem WHERE Version like "5.2.3%" AND ProductType="2"

Windows Server 2003 R2 - non-DC

select * from Win32_OperatingSystem WHERE Version like "5.2.3%" AND ProductType="3"

Windows Server 2003 R2 - 32-bit - DC

select * from Win32_OperatingSystem WHERE Version like "5.2.3%" AND ProductType="2" AND NOT OSArchitecture = "64-bit"

Windows Server 2003 R2 - 32-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "5.2.3%" AND ProductType="3" AND NOT OSArchitecture = "64-bit"

Windows Server 2003 R2 - 64-bit - DC

select * from Win32_OperatingSystem WHERE Version like "5.2.3%" AND ProductType="2" AND OSArchitecture = "64-bit"

Windows Server 2003 R2 - 64-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "5.2.3%" AND ProductType="3" AND OSArchitecture = "64-bit"

Windows Server 2008 - DC

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="2"

Windows Server 2008 – non-DC

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="3"

Windows Server 2008 - 32-bit - DC

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="2" AND NOT OSArchitecture = "64-bit"

Windows Server 2008 - 32-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="3" AND NOT OSArchitecture = "64-bit"

Windows Server 2008 - 64-bit - DC

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="2" AND OSArchitecture = "64-bit"

Windows Server 2008 - 64-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "6.0%" AND ProductType="3" AND OSArchitecture = "64-bit"

Windows Server 2008 R2 - 64-bit - DC

select * from Win32_OperatingSystem WHERE Version like "6.1%" AND ProductType="2"

Windows Server 2008 R2 - 64-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "6.1%" AND ProductType="3"

Windows Server 2012 - 64-bit - DC

select * from Win32_OperatingSystem WHERE Version like "6.2%" AND ProductType="2"

Windows Server 2012 - 64-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "6.2%" AND ProductType="3"

Windows Server 2012 R2 - 64-bit - DC

select * from Win32_OperatingSystem WHERE Version like "6.3%" AND ProductType="2"

Windows Server 2012 R2 - 64-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "6.3%" AND ProductType="3"

Windows Server 2016 - 64-bit - DC

select * from Win32_OperatingSystem WHERE Version like "10.%" AND ProductType="2"

Windows Server 2016 - 64-bit - non-DC

select * from Win32_OperatingSystem WHERE Version like "10.%" AND ProductType="3"