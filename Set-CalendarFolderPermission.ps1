param([string]$Mailbox,[string]$Delegate,[string]$Permission,[string]$AuthUsername,[string]$AuthPassword,[string]$AuthDomain,[bool]$Impersonate,[string]$EwsUrl,[string]$EWSManagedApiPath,[bool]$IgnoreSSLCertificate,[bool]$WhatIf);
 
#
# Set-CalendarFolderPermission.ps1
#
# By David Barrett, Microsoft Ltd. 2012. Use at your own risk.  No warranties are given.
#
#  DISCLAIMER:
# THIS CODE IS SAMPLE CODE. THESE SAMPLES ARE PROVIDED "AS IS" WITHOUT WARRANTY OF ANY KIND.
# MICROSOFT FURTHER DISCLAIMS ALL IMPLIED WARRANTIES INCLUDING WITHOUT LIMITATION ANY IMPLIED WARRANTIES OF MERCHANTABILITY OR OF FITNESS FOR
# A PARTICULAR PURPOSE. THE ENTIRE RISK ARISING OUT OF THE USE OR PERFORMANCE OF THE SAMPLES REMAINS WITH YOU. IN NO EVENT SHALL
# MICROSOFT OR ITS SUPPLIERS BE LIABLE FOR ANY DAMAGES WHATSOEVER (INCLUDING, WITHOUT LIMITATION, DAMAGES FOR LOSS OF BUSINESS PROFITS,
# BUSINESS INTERRUPTION, LOSS OF BUSINESS INFORMATION, OR OTHER PECUNIARY LOSS) ARISING OUT OF THE USE OF OR INABILITY TO USE THE
# SAMPLES, EVEN IF MICROSOFT HAS BEEN ADVISED OF THE POSSIBILITY OF SUCH DAMAGES. BECAUSE SOME STATES DO NOT ALLOW THE EXCLUSION OR LIMITATION
# OF LIABILITY FOR CONSEQUENTIAL OR INCIDENTAL DAMAGES, THE ABOVE LIMITATION MAY NOT APPLY TO YOU.


# Define our functions

Function ShowParams()
{
	Write-Host "Set-CalendarFolderPermission -Mailbox <string>"
	Write-Host "                  -Delegate <string>"
	Write-Host "                  -Permission <string>"
	Write-Host "                   [-AuthUsername <string> -AuthPassword <string> [-AuthDomain <string>]]"
	Write-Host "                   [-Impersonate <bool>]"
	Write-Host "                   [-EwsUrl <string>]"
	Write-Host "                   [-EWSManagedApiPath <string>]"
	Write-Host "                   [-IgnoreSSLCertificate <bool>]"
	Write-Host "                   [-WhatIf <bool>]"
	Write-Host ""
	Write-Host "Required:"
	Write-Host " -Mailbox : Mailbox SMTP email address, OR CSV file containing list of mailboxes to process"
	Write-Host " -Delegate : Email address of the user who is being given the permissions (or can use Default or Anonymous)"
	Write-Host " -Permission : None, Owner, PublishingEditor, Editor, PublishingEditor, Author, NoneditingAuthor, Reviewer, Contributor, FreeBusyTimeOnly, FreeBusyTimeAndSubjectAndLocation"
	Write-Host ""
	Write-Host "Optional:"
	Write-Host " -AuthUsername : Username for the account being used to connect to EWS (if not specified, current user is assumed)"
	Write-Host " -AuthPassword : Password for the specified user (required if username specified)"
	Write-Host " -AuthDomain : If specified, used for authentication (not required even if username specified)"
	Write-Host " -Impersonate : Set to $true to use impersonation."
	Write-Host " -EwsUrl : Forces a particular EWS URl (otherwise autodiscover is used, which is recommended)"
	Write-Host " -EWSManagedApiDLLFilePath : Full and path to the DLL for EWS Managed API (if not specified, default path for v1.2 is used)"
	Write-Host " -IgnoreSSLCertificate : If $true, then any SSL errors will be ignored"
	Write-Host " -WhatIf : If $true, then no changes are saved"
	Write-Host ""
}

Function SetFolderPermission()
{
	# We want to set the folder permissions
	# $FolderId is the id of the folder we want to update
	# $Delegate is the user for whom we want to change permissions
	# $RequiredPermission is the permission we are going to set
	
	Write-Host "Processing mailbox:" $Mailbox -ForegroundColor White

	# Set EWS URL if specified, or use autodiscover if no URL specified.
	if ($EwsUrl)
	{
		$service.URL = New-Object Uri($EwsUrl)
	}
	else
	{
		try
		{
			Write-Host "Performing autodiscover for $Mailbox" -ForegroundColor Gray
			$service.AutodiscoverUrl($Mailbox)
			Write-Host "EWS Url found: ", $service.Url -ForegroundColor Gray
		}
		catch
		{
			throw "Failed to perform Autodiscover.  Is the SSL certificate valid?"
		}
	}
	 
	# Set impersonation if specified
	if ($Impersonate)
	{
		Write-Host "Impersonating $Mailbox" -ForegroundColor Gray
		$service.ImpersonatedUserId = New-Object Microsoft.Exchange.WebServices.Data.ImpersonatedUserId([Microsoft.Exchange.WebServices.Data.ConnectingIdType]::SmtpAddress, $Mailbox)
		$FolderId = [Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Calendar
	}
	else
	{
		# If we're not impersonating, we will specify the mailbox in case we are accessing a mailbox that is not the authenticating account's
		$mbx = New-Object Microsoft.Exchange.WebServices.Data.Mailbox( $Mailbox )
		$FolderId = New-Object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::Calendar, $mbx )
	}

	$PropertySet = New-Object Microsoft.Exchange.WebServices.Data.PropertySet([Microsoft.Exchange.WebServices.Data.BasePropertySet]::IdOnly, [Microsoft.Exchange.WebServices.Data.FolderSchema]::Permissions)
	$Folder = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($service, $FolderId, $PropertySet)
	
	$permUpdated = $false
	foreach ( $permission in $Folder.Permissions )
	{
		if ( ($Delegate -eq "Default") -or ($Delegate -eq "Anonymous") )
		{
			# We are updating a standard permission
			if ( ![string]::IsNullOrEmpty( $permission.UserId.StandardUser ) )
			{
				Write-Host "Standard user:" $permission.UserId.StandardUser -ForegroundColor Gray
				if ( $permission.UserId.StandardUser -eq $Delegate )
				{
					# Update this permission
					$permission.PermissionLevel = $RequiredPermission
					Write-Host "Permission for $Delegate updated to" $permission.PermissionLevel -foregroundcolor Green
					$permUpdated = $true
				}
				else
				{
					Write-Host "Permission level:" $permission.PermissionLevel -ForegroundColor Gray
				}
			}
		}
		else
		{
			# We are updating a user's permission
			if ( ![string]::IsNullOrEmpty( $permission.UserId.PrimarySmtpAddress ) )
			{
				Write-Host "User SMTP address:" $permission.UserId.PrimarySmtpAddress -ForegroundColor Gray
				if ( $permission.UserId.PrimarySmtpAddress.ToLower() -eq $Delegate.ToString().ToLower() )
				{
					# Update this permission
					$permission.PermissionLevel = $RequiredPermission
					Write-Host "Permission for $Delegate updated to" $permission.PermissionLevel -foregroundcolor Green
					$permUpdated = $true
				}
				else
				{
					Write-Host "Permission level:" $permission.PermissionLevel -ForegroundColor Gray
				}
			}
		}
	}
	
	if ( !$permUpdated )
	{
		# We didn't find the permission in the existing permission set, so we'll try to add it
		if ( ![string]::IsNullOrEmpty( $Delegate ) )
		{
			$newPermission = New-Object Microsoft.Exchange.WebServices.Data.FolderPermission( $Delegate, $RequiredPermission )
			$Folder.Permissions.Add( $newPermission )
			Write-Host "Permission for $Delegate added" -ForegroundColor Green
			$permUpdated = $true
		}
	}
	
	if ( $permUpdated )
	{
		if ( !$WhatIf )
		{
			Write-Host "Applying changes" -foregroundcolor Green
			$Folder.Update()
		}
	}
	else
	{
		Write-Host "No permissions were modified." -ForegroundColor Yellow
	}
}


# The following is the main script


 
# Check mailbox email address
 if (!$Mailbox)
 {
	ShowParams;
    throw "Required parameter Mailbox missing"
 }
 
# Check EWS Managed API available (we can use 1.1 or 1.2)
 if (!$EWSManagedApiPath)
 {
	$EWSManagedApiPath = "C:\Program Files\Microsoft\Exchange\Web Services\1.2\Microsoft.Exchange.WebServices.dll"
	if (!(Get-Item -Path $EWSManagedApiPath -ErrorAction SilentlyContinue))
	{
		$EWSManagedApiPath = "C:\Program Files\Microsoft\Exchange\Web Services\1.1\Microsoft.Exchange.WebServices.dll"
	}
 }
if (!(Get-Item -Path $EWSManagedApiPath -ErrorAction SilentlyContinue))
{
	throw "EWS Managed API could not be found at $($EWSManagedApiPath)."
}
 
# Load EWS Managed API
 Add-Type -Path $EWSManagedApiPath
 
# Create Service Object.  We use Exchange 2010 schema
$service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService([Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2007_SP1)

# If we are ignoring any SSL errors, set up a callback
if ($IgnoreSSLCertificate)
{
	Write-Host "WARNING: Ignoring any SSL certificate errors" -foregroundColor Yellow
	[System.Net.ServicePointManager]::ServerCertificateValidationCallback = { $true }
}


# Set credentials if specified, or use logged on user.
 if ($Delegate -and $Password)
 {
	Write-Host "Applying given credentials for", $Delegate
	if ($Domain)
	{
		$service.Credentials = New-Object  Microsoft.Exchange.WebServices.Data.WebCredentials($Delegate,$Password,$Domain)
	} else {
		$service.Credentials = New-Object  Microsoft.Exchange.WebServices.Data.WebCredentials($Delegate,$Password)
	}

} else {
	Write-Host "Using default credentials"
    $service.UseDefaultCredentials = $true
 }
 

# Parse the status required to FolderPermissionLevel enumeration
switch ($Permission.ToLower())
{
	"none"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::None
	}
	
	"owner"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::Owner
	}
	
	"publishingeditor"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::PublishingEditor
	}
	
	"editor"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::Editor
	}
	
	"publishingauthor"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::PublishingAuthor
	}
	
	"author"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::Author
	}
	
	"noneditingauthor"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::NoneditingAuthor
	}
	
	"reviewer"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::Reviewer
	}
	
	"contributor"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::Contributor
	}
	
	"freebusytimeonly"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::FreeBusyTimeOnly
	}
	
	"freebusytimeandsubjectandlocation"
	{
		$RequiredPermission = [Microsoft.Exchange.WebServices.Data.FolderPermissionLevel]::FreeBusyTimeAndSubjectAndLocation
	}
}

Write-Host ""

# Check whether we have a CSV file as input...
$FileExists = Test-Path $Mailbox
If ( $FileExists )
{
	# We have a CSV to process
	$csv = Import-CSV $Mailbox
	foreach ($entry in $csv)
	{
		$Mailbox = $entry.PrimarySmtpAddress
		if ( [string]::IsNullOrEmpty($Mailbox) -eq $False )
		{
			SetFolderPermission
		}
	}
}
Else
{
	# Process as single mailbox
	SetFolderPermission
}