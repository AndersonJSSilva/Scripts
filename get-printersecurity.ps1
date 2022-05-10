$pace = DATA {            
ConvertFrom-StringData -StringData @'
983052 = ManagePrinters
983088 = ManageDocuments
131080 = Print 
524288 = TakeOwnership
131072 = ReadPermissions
262144 = ChangePermissions 
'@            
}             
$flags = @(983052,983088, 131080, 524288, 131072, 262144)            
            
$computer="neoappprd05"       
 Get-WmiObject -Class Win32_Printer -ComputerName $computer |            
 foreach {            
  "`nPrinter: $($_.DeviceId)"            
  $query = "ASSOCIATORS OF {Win32_Printer.DeviceID='$($_.DeviceID)'} WHERE ResultClass=Win32_Share"            
  Get-WmiObject -ComputerName $computer -Query $query |             
  foreach {            
    ""            
    "Share: $($_.Name)"            
                
    $query2 = "ASSOCIATORS OF {Win32_Share.Name='$($_.Name)'} WHERE ResultClass=Win32_LogicalShareSecuritySetting"            
    $sec = Get-WmiObject -ComputerName $computer -Query $query2            
    $sd = $sec.GetSecurityDescriptor()            
    $sd.Descriptor.DACL | foreach {            
      ""             
      "$($_.Trustee.Domain)  $($_.Trustee.Name)"            
                  
      foreach ($flag in $flags){            
        if ($_.AccessMask -band $flag){            
          $pace["$($flag)"]            
        }            
      }            
    }            
  }            
 }            
