$computername = "rasmonprd01"

        Write-Host "Computer in called func: $computername"
        Write-Host "Path in called func: $sharename"
        $SharedObj = Get-WmiObject -Class Win32_LogicalShareSecuritySetting -ComputerName $computername 
        ForEach ($MyShare in ($SharedObj | Where {$_.Name -eq $sharename})){ 
               
                $MySecurityDescriptor = $MyShare.GetSecurityDescriptor() 
                $myCol = @() 
                ForEach ($DACL in $MySecurityDescriptor.Descriptor.DACL) 
                { 
                        $myObj = "" | Select Domain, ID, AccessMask, AceType 
                        $myObj.Domain = $DACL.Trustee.Domain
                        $myObj.ID = $DACL.Trustee.Name 
                        
                        Switch ($DACL.AccessMask) 
                        { 
                                2032127 {$AccessMask = "FullControl"} 
                                1179785 {$AccessMask = "Read"} 
                                1180063 {$AccessMask = "Read, Write"} 
                                1179817 {$AccessMask = "ReadAndExecute"} 
                                -1610612736 {$AccessMask = "ReadAndExecuteExtended"} 
                                1245631 {$AccessMask = "ReadAndExecute, Modify, Write"} 
                                1180095 {$AccessMask = "ReadAndExecute, Write"} 
                                268435456 {$AccessMask = "FullControl (Sub Only)"} 
                                default {$AccessMask = $DACL.AccessMask} 
                        } 
                        $myObj.AccessMask = $AccessMask
                        $opWorkSheetObj.cells.item($intOpExcelRow,5) = $myObj.AccessMask 
                        Switch ($DACL.AceType) 
                        { 
                                0 {$AceType = "Allow"} 
                                1 {$AceType = "Deny"} 
                                2 {$AceType = "Audit"} 
                        } 
                        $myObj.AceType = $AceType 
                        $opWorkSheetObj.cells.item($intOpExcelRow,6) = $myObj.AceType
                        Clear-Variable AccessMask -ErrorAction SilentlyContinue 
                        Clear-Variable AceType -ErrorAction SilentlyContinue 
                        $myCol += $myObj                         
                } 
        } 
$myCol 
