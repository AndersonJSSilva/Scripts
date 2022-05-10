# Load the EWS dll to handle individual emails/attachments
 Add-Type -Path "C:\Program Files\Microsoft\Exchange\Web Services\2.0\Microsoft.Exchange.WebServices.dll"
 $ExchangeVersion = [Microsoft.Exchange.WebServices.Data.ExchangeVersion]::Exchange2007_SP1

 # Glen's blog has routines for using autodiscover to pick up some of these pieces
 # and code for impersonating a different user, but I hardcoded values I needed
 # for this specific script.
 $service = New-Object Microsoft.Exchange.WebServices.Data.ExchangeService($ExchangeVersion)
 $creds = New-Object System.Net.NetworkCredential("unimedrj\adm41718","senhadificil")
 $service.Credentials = $creds
 $uri = [system.URI] "https://hubcasprd01/ews/exchange.asmx"
 $service.Url = $uri
 $MailboxName = "adm41718@unimedrio.com.br"

 #Bind to Sent Items folder
 $folderid= new-object Microsoft.Exchange.WebServices.Data.FolderId([Microsoft.Exchange.WebServices.Data.WellKnownFolderName]::inbox,$MailboxName) 
 $SentItems = [Microsoft.Exchange.WebServices.Data.Folder]::Bind($service,$folderid) 

 # Define that I only want messages with *.pdf attachments. 
 $AttachmentContent = ".pdf"
 $AQSString = "System.Message.AttachmentContents:$AttachmentContent"

 #Define ItemView to retrive just 1000 Items at a time
 $ivItemView = New-Object Microsoft.Exchange.WebServices.Data.ItemView(1000) 
 $fiItems = $null 
 do{

 $fiItems =$sentItems.FindItems($ivItemView)
 #$fiItems = $service.FindItems($SentItems.Id,$AQSString,$ivItemView) 
 #[Void]$service.LoadPropertiesForItems($fiItems,$psPropset) 
 foreach($Item in $fiItems.Items)
 { 
    write-host $Item.subject $Item.DateTimeReceived $Item.Attachments.
    $Item.Load()
    $attachtoDelete = @()
    foreach ($Attachment in $Item.Attachments)
    {
        $Attachment.Load()
        $attachtoDelete += $Attachment
        <#
        if($Attachment -is [Microsoft.Exchange.WebServices.Data.FileAttachment])
        { 
            if($Attachment.Name.Contains(".pdf"))
            {
                $Attachment.Name
                $attachtoDelete += $Attachment
            }
        } #>

        $Attachment.Load()
        
    }
    $updateItem = $false
    foreach($AttachmentToDelete in $attachtoDelete)
    {
        #$Item.Attachments.Remove($AttachmentToDelete)
        #$Item.Attachments
        $updateItem = $true
    }
    # Resave the email now with the attachments removed
    if($updateItem)
    {
        $Item.Update([Microsoft.Exchange.WebServices.Data.ConflictResolutionMode]::AlwaysOverWrite)};
    } 
    $ivItemView.Offset += $fiItems.Items.Count

 }while($fiItems.MoreAvailable -eq $true) 