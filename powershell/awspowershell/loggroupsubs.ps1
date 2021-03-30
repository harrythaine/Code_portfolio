#gets subscribers for cloudtrail's default log group and the vpc-flow-logs in eu-west-1/2  

#as a lot of these are expected to be null, this is here to prevent bloat from the output
$ErrorActionPreference= 'silentlycontinue'

#uses profiles your your machine to get a list of AWS profiles to run against
$profiles = (Get-AWSCredential -ListProfileDetail) 
#filtered profiles is here to removes CLI creds and only uses the name of the PowerShell creds
$filteredprofiles = @() 

#populates $filteredprofiles
foreach ($profile in $profiles){ 
    if($profile.StoreTypeName -eq "NetSDKCredentialsFile") { 
        $filteredprofiles += $profile.profilename
    } 
} 

#runs ones for each account
foreach($account in $filteredprofiles){

#gets all logroups in the account
$loggroupsIRE = Get-CWLLogGroup -Region eu-west-1 -ProfileName $account
$loggroupsLON = Get-CWLLogGroup -Region eu-west-2 -ProfileName $account
$loggroupsIRE2 = @()
$loggroupsLON2 = @()

#populates the ireland and london log groups with "VPC-Flow-Logs" and "CloudTrail/defaultloggroup", if you want to expand the scope to all loggroups remove the If statement and replace with:
<#
foreach($group in $loggroupsIRE){
    $loggroupsIRE2 += $group.LogGroupName
    }

foreach($group in $loggroupsLON){
    $loggroupsLON2 += $group.LogGroupName
    }
#>

foreach($group in $loggroupsIRE){
    if($group.LogGroupName -eq "VPC-Flow-Logs"){
    $loggroupsIRE2 += $group.LogGroupName
    }
    elseif($group.LogGroupName -eq "CloudTrail/DefaultLogGroup"){
    $loggroupsIRE2 += $group.LogGroupName
    }

}

foreach($group in $loggroupsLON){
    if($group.LogGroupName -eq "VPC-Flow-Logs"){
    $loggroupsLON2 += $group.LogGroupName
    }
    elseif($group.LogGroupName -eq "CloudTrail/DefaultLogGroup"){
    $loggroupsLON2 += $group.LogGroupName
    }

}

#gets the account ID of the AWS Account
$accountId = (Get-STSCallerIdentity -region eu-west-1 -ProfileName $account).Account
#$accountId



#resets log groups so they're null for the next loop, needed to prevent duplications
$subfilterIRE1 = ""
$subfilterIRE2 = ""
$subfilterLON1 = ""
$subfilterLON2 = ""


#gets the subscribers for CloudTrail/DefaultLogGroup, and "VPC-Flow-Logs" gets the name, Role Arn and Destination Arn for both Ireland and London
$subfilterIRE1 = Get-CWLSubscriptionFilter -LogGroupName "CloudTrail/DefaultLogGroup" -Region eu-west-1 -ProfileName $account -ErrorAction SilentlyContinue
#$subfilterIRE1
$roleARNIRE1 = $subfilterIRE1.RoleArn
$destARNIRE1 = $subfilterIRE1.DestinationArn

$subfilterIRE2 = Get-CWLSubscriptionFilter -LogGroupName "VPC-Flow-Logs" -Region eu-west-1 -ProfileName $account -ErrorAction SilentlyContinue
#$subfilterIRE2
$roleARNIRE2 = $subfilterIRE2.RoleArn
$destARNIRE2 = $subfilterIRE2.DestinationArn

$subfilterLON1 = Get-CWLSubscriptionFilter -LogGroupName "CloudTrail/DefaultLogGroup" -Region eu-west-2 -ProfileName $account -ErrorAction SilentlyContinue
#$subfilterLON1
$roleARNLON1 = $subfilterLON1.RoleArn
$destARNLON1 = $subfilterLON1.DestinationArn

$subfilterLON2 = Get-CWLSubscriptionFilter -LogGroupName "VPC-Flow-Logs"-Region eu-west-2 -ProfileName $account -ErrorAction SilentlyContinue
#$subfilterLON2
$roleARNLON2 = $subfilterLON2.RoleArn
$destARNLON2 = $subfilterLON2.DestinationArn


#gives the output
Write-Host  " ___________________________________________________________________________________________________________________________________________________________ " 
""
Write-Host -nonewline "|   Account    |     AccountID     |   region     |    Log Group Name    |    Dest ARN    |       RoleARN                                  |"
""
#Write-Host -nonewline "Account" "|" "AccountID" "|" "region" "|" "Log Group Name" "|" "Dest ARN" "|" "RoleARN"  "|" ""
""
Write-Host -NoNewline "|" $account "|" $accountId  "|" "eu-west-1" "|" $loggroupsIRE2[0]  "|"  $destARNIRE1  "|"  $roleARNIRE1 "|" -ErrorAction SilentlyContinue
""
Write-Host -NoNewline "|" $account "|" $accountId  "|" "eu-west-1" "|" $loggroupsIRE2[1]  "|"  $destARNIRE2  "|"  $roleARNIRE2 "|" -ErrorAction SilentlyContinue
"" 
Write-Host -NoNewline "|" $account "|" $accountId  "|" "eu-west-2" "|" $loggroupsLON2[0]  "|"  $destARNLON1  "|"  $roleARNLON1 "|" -ErrorAction SilentlyContinue
""
Write-Host -NoNewline "|" $account "|" $accountId  "|" "eu-west-2" "|" $loggroupsLON2[1]  "|"  $destARNLON2  "|"  $roleARNLON2 "|" -ErrorAction SilentlyContinue
""
#$roleARN
#$destARN


}


