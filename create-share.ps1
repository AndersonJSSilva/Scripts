################################################################### 
#   create-share
#     use the administrative shares for the remote folder creation 
#     and win32_share for the share creation
#   set-permission
#      use iCacls.exe, a quick solution instead of set-acl
#   bye gastone canali
#   v 0.2 01-01-2013
###################################################################
    Function Create-Share ($computername, $FolderName , $ShareName) 
	{
		$Fullcontrol=2032127
    	$Change=1245631
    	$read=1179817
		$allow=0
		$deny=1
		$Description="$ShareName Gas"
		
		$sd = ([WMIClass] "Win32_SecurityDescriptor").CreateInstance()
		#for authenticated users - change
    	$ACE = ([WMIClass] "Win32_ACE").CreateInstance()
    	$Trustee = ([WMIClass] "Win32_Trustee").CreateInstance()
    	$Trustee.Name = "authenticated users" #username 
    	$Trustee.Domain = $Null
    	$ace.AccessMask = $change 
    	$ace.AceFlags = 3 
    	$ace.AceType = $allow
    	$ACE.Trustee = $Trustee 
    	$sd.DACL += $ACE.psObject.baseobject 

    	# Domain Admins - full control 
    	$ACE = ([WMIClass] "Win32_ACE").CreateInstance()
    	$Trustee = ([WMIClass] "Win32_Trustee").CreateInstance()
    	$Trustee.Name = "Domain Admins"
    	$Trustee.Domain = $Null  
    	$ace.AccessMask = $Fullcontrol
    	$ace.AceFlags = 3
    	$ace.AceType = $allow
    	$ACE.Trustee = $Trustee 
    	$sd.DACL += $ACE.psObject.baseobject
	
		$Shares=[WMICLASS]"WIN32_Share"
	    $UncPath="\\$computername\" + ($FolderName -replace ":","$") 
		$Error.Clear()
		
		if (!(Test-Path  $UncPath)) 
		{ 
            if (!(Get-WMIObject Win32_share -computername $computername -filter "name='$ShareName'"))
            {   #create remote folder
				New-Item $UncPath -type Directory
				#create remote share
                $Shares.Create($FolderName,$ShareName,0,$null,$Description,$null,$sd)
                if (!($error)){$true} else {Remove-Item $UncPath ;  $false}
            } else {
			    "Error"
				$false
		    }
		}
	}
	
    Function set-permission ($fullpath,$user) {
	   #(OI)(CI)	    This folder, subfolders, and files.
       #(OI)(CI)(IO)	Subfolders and files only.
       #    (CI)(IO)    Subfolders only.
       #(OI)    (IO)	Files only.
	   #F=full control # M=modify # RX=read and execute # R=read-only # W=write-only access
	   $systemFC="system:(OI)(CI)(F)"
	   if ($user -ne $nul) {$userFC="`"$user`:(OI)(CI)(F)`""}
	   $adminsFC="BUILTIN\administrators:(OI)(CI)(F)"
	   cmd.exe /c "icacls `"$fullpath`" /inheritance:r /grant:r  $userFC  $systemFC $adminsFC /t"
	 }
	 
	 cls
	 
	 #Create a single share
	 $remote_pc="$env:computername" #"MyPC"
	 $dir="d:\AZZZ"
	 $ShareName="AZZZ"
	 $fullSharename="\\$remote_pc\" + ($dir -replace ":","$")
	 if (create-share  -computername $remote_pc -FolderName $dir -Sharename $ShareName) 
	 {
	     set-permission -fullpath $fullSharename -user "mydom\gastone.canali"
	 }
	 
	 # create multiple shares
	 $remote_pc="TheServer"
	 $rootdir="f:\usr"
	 $domain="mydom"
	 
	 Get-Content "c:\temp\users.txt" | % {
	    $dir="$rootdir\$_"
		$sharename="$_"
	 	$fullSharename="\\$remote_pc\" + ($dir -replace ":","$")
	 	if (create-share  -computername $remote_pc -FolderName $dir -Sharename $ShareName) 
	 	{
	     	set-permission -fullpath $fullSharename -user "$domain\$_"
	 	}
	 }