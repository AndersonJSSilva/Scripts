#Install-Module -Name AWSPowerShell
#Import-Module "C:\Program Files (x86)\AWS Tools\PowerShell\AWSPowerShell\AWSPowerShell.psd1"
Set-AWSCredential -AccessKey AKIAJCODEWNW7MHUEPMQ -SecretKey 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 -StoreAs carlosdavid
Get-AWSCredential -ListProfileDetail
Set-AWSCredential -ProfileName carlosdavid
Initialize-AWSDefaultConfiguration -ProfileName carlosdavid -Region sa-east-1

$EC2Instances = Get-EC2Instance  
$RDSInstances = Get-RDSDBInstance 

foreach($ec2 in $EC2Instances)
{
    #$ec2.RunningInstance.state   
    if($ec2.RunningInstance.state.Name -eq "running")
    {
         #$ec2.Instances.instanceid | Stop-EC2Instance 
         $ec2.Instances.tag.value
     }
}

foreach($rds in $RDSInstances)
{
    $rds | select DBInstanceIdentifier, DBInstanceClass,  dbinstancestatus, engine, engineversion
    
    #$rds | Stop-RDSDBInstance

}


$ec2 = Get-EC2Instance | ? { $_.instances.tag.value -like "webapp*" }
$ec2.Instances.tags | select *

( (Get-EC2Instance -ProfileName carlosdavid -Region sa-east-1 | ? { $_.instances.tag.value -match "web01" } ).Instances).InstanceID | Start-EC2Instance

( (Get-EC2Instance -Region sa-east-1 | ? { $_.instances.tag.value -match "web01"} ).Instances).InstanceID | Stop-EC2Instance 

