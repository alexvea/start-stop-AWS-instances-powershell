#Import (unversioned) config_file.ps1
. ./config_file.ps1


## Function to check if folder where shortcuts will be created exist or not.
## It will delete 
function CreateFolder {
    
Write-Host "## Check if $FolderName folder exist. ##"
if (Test-Path $FolderName) {
     
    Write-Host "## Deleting every AWS shortcuts.##"
    # Perform Delete file from folder operation
    Get-ChildItem $FolderName\*-AWS-*.lnk | Remove-Item 
}
else
    {
        #PowerShell Create directory if not exists
        New-Item $FolderName -ItemType Directory
        Write-Host "## Folder Created successfully. ##"
    }
}


function Create-instance-shortcut {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory)]
        [string]$InstanceName = $env:INSTANCENAME
    ,
        [Parameter(Mandatory)]
        [string]$InstanceID = $env:INSTANCEID
    ,

        [Parameter(Mandatory)]
        [string]$InstanceStatus = $env:INSTANCESTATUS
    )
Write-Host "Creating shortcut for instance $InstanceName."
        $Action=""
        $ShortcutIcon=""
        Switch ($InstanceStatus)
            {
               "stopped" {
                    $Action="start"

                    # key icon
                    $IconArrayIndex = 44
               }
               "running" {
                    $Action="stop"
                    # stop icon
                    $IconArrayIndex = 27
               }
               default 
               { 
                    $Action="describe"
                    $IconArrayIndex = 22
                    # magnifying glass icon

               }  
            }
   
        $WshShell = New-Object -comObject WScript.Shell
        $Shortcut = $WshShell.CreateShortcut("$FolderName\$Action -AWS- $InstanceName.lnk")
        $Shortcut.IconLocation = "$IconLocation, $IconArrayIndex"
        $Shortcut.TargetPath = "cmd.exe"
        $Shortcut.Arguments = "/q /c aws ec2 $Action-instances --profile $AwsProfile --instance-ids $InstanceID"
        $Shortcut.Save()
}


function GetInstancesList {
   
    [CmdletBinding()]
    param (
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$UserName = $env:USERNAME
    ,
        [ValidateNotNullOrEmpty()]
        [Parameter(Mandatory = $true)]
        [string]$AwsProfile = $env:AWSPROFILE
    )

$MultipleInstancesStop=""
Write-Host "## Getting AWS Instances for $UserName user. ##"
Write-Host "## With tag Schedule stop-only (to exclude shared instances). ##"
## List all instances with tag User=@Username@ and tag Schedule=stop-only. 
# Example of output 
# i-0c30xxxxx   avea-xxxxxxx   stopped
# i-0a7xxxxxx   avea-old-x     stopped
# i-04fbxxxxx   avea-old-xxxx  stopped
# i-02xxxxxxxx  avea-old-xxxxx stopped
# i-018xxxxx    avea-cent      running
aws ec2 describe-instances --filters Name=tag:User,Values=$UserName Name=tag:Schedule,Values=stop-only --profile $AwsProfile --output text --query "Reservations[*].Instances[*].{Instance_id:InstanceId,Name:Tags[?Key=='Name'].Value | [0],Instance_id:InstanceId,State:State.Name}" | %{ 
    Create-instance-shortcut -InstanceName $_.split("`t")[1] -InstanceID $_.split("`t")[0] -InstanceStatus $_.split("`t")[2]

    #Case for multi-instances stop (from instance status) in the loop for each.
    If($_.split("`t")[2] -eq "running") 
        { 
            $MultipleInstancesStop=$MultipleInstancesStop+" "+$_.split("`t")[0]
        }   
    # End of for each
    }
#Case for multi-instances stop (from instance status) outside the loop for each, to create the shortcut.
if($MultipleInstancesStop -ne "")
    {
        Create-instance-shortcut -InstanceName all-running-instances-of-$UserName-stop-only -InstanceID $MultipleInstancesStop -InstanceStatus running
    }
}

CreateFolder

GetInstancesList -UserName $UserName -AwsProfile $AwsProfile

Write-Host "## Closing in $SleepTime seconds...##"
Start-Sleep $SleepTime

