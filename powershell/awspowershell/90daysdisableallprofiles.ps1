#################################################################################################################
#       This Script retires access keys if they haven't been used in the last 90 days                           #
#       V.0.1. Script's logic works                                                                             #
#       V.0.2 The script now runs through all AWS Accounts                                                      #
#       V.0.3 write-hosts removed to just leave end output                                                      #
#       v.0.4 this script calls a second script that sets and updates all of the AWS Powershell profiles        #
#       v.0.5. Updated awsprofile names, added a "#requires" to beginning of the script                         #
#                                                                                                               #
#################################################################################################################

#Requires -Modules @{ModuleName='AWSPowerShell';ModuleVersion='3.3.563.1'}

#sets an array of the AWS PowerShell profiles
$awsprofiles = @(   "local-profiles-here-1",        
                    "local-profiles-here-2")

############################################################################################################

#runs once for each AWS Profile
foreach($profile in $awsprofiles){
    #$deletedusers = @()
    Write-Host "_____________________________________________________________"
    Write-Host $profile
    Write-Host "_____________________________________________________________"
    Set-AWSCredential -ProfileName $profile

    #creates an empty array
    $iamlastusedarray = @()
    $iamaccesskeyarray = @()
    #gets the date 90 days ago
    $90daysago = (Get-Date).Adddays(-90)

    #get a list of access keys
    $allusers = Get-IAMUserList
    $allusernames = $allusers.UserName
    
    foreach ($username in $allusernames){
        $accesskey = Get-IAMAccessKey -UserName $username
        $iamaccesskeyarray +=  $accesskey.AccessKeyId
    }
    #for every access key id, get the user name and the last time it was used
    foreach ($key in $iamaccesskeyarray){
        $lastIAMuse = Get-IAMAccessKeyLastUsed -AccessKeyId $key 
        $iamlastusedarray += $lastIAMuse

    }

    #if the IAM user account has been used within the last 90 days nothing will happen, if it hasn't been used in the last 90 days the access key will be deleted
    foreach($user in $iamlastusedarray){
        $userlastused = $user.AccessKeyLastUsed.LastUsedDate
        #less than is the one you want to disable
        if($userlastused -lt $90daysago){
            write-host $user.UserName -ForegroundColor Red
            write-host "Access key WOULD be deleted" 

            #uncomment the below to remove the access key (doesn't delete the IAM user)
            #Remove-IAMAccessKey -UserName $user.UserName
    }
        else{
            write-host $user.UserName -ForegroundColor Green
            write-host "Access key WOULD NOT be deleted" 
    }

    }
}
