<#
date created: 12/06/2019
Update: 17/06/2019: Added AAD applications snapshots to the code


prerequisites:
    1)  run with local admin account   
    2)  run this script from C: drive
    4)  Have the "AzureRM" modules installed, to install this enter 'Install-Module AzureRM' in an elivated powershell session
    5)  After installing these modules, check that you have version '5.8.3' for 'AzureRM.Profile' to check this enter 'get-module' in powershell, if your version is below 5.8.3 enter the following command 'Install-Module AzureRM.Profile -RequiredVersion 5.8.3' (NOTE: this is to prevent a bug with token authentication on version 5.8.2 and below)
    6)  in powershell, log into Azure using the following commands: 'Connect-AzureRmAccount' click yes on the pop up and enter your username and password
    7)  use the command 'Save-AzureRmContext -path "C:\Users\user\scripts\azureprofile.json"' this is save a copy of your login details that can be called later by the script in order to log on
    8)  have the AWS CLI tool installed https://docs.aws.amazon.com/cli/latest/userguide/install-windows.html
    9)  go to c:\users\user\ and create a folder called ".aws" and put the "config" & "credentials" file in this folder
    10)  go to c:\users\user\ and create the following folders "awslocal", "awssyncfiles" & "azurelocal"
    11) change any instance of "user" to your user name
#>
#Install-Module AzureRM
#Connect-AzureRmAccount
#'Save-AzureRmContext -path "C:\Users\user\azureprofile.json


#Ctrl + F for "C:\Users\user". REPLACE WITH FILEPATH FOR SCRIPT SERVER 

#Checks to see if the directory that holds the Azure login information exists, if it doesn't this creates it
$pathAzProfiledirectory = "C:\Users\user\"
If(!(test-path $pathAzProfiledirectory))
{
    New-Item -ItemType Directory -Force -Path $pathAzProfiledirectory
}

#checks to see if the profile infoarmation exists, if it doesn't then it will have you manually login 
$pathAzProfileFile = "C:\Users\user\scripts\azureprofile.json"
If(!(test-path $pathAzProfileFile))
{
      Connect-AzureRmAccount
}


#lines 37-43 are used to connect to Azure
Clear-AzureRMContext -force
enable-AzureRMContextAutosave -Scope CurrentUser 
Import-AzureRMContext -Path "C:\Users\user\azureprofile.json"
Get-AzureRmContext
#used to see if the connection was successful
Get-AzureRMSubscription            #-WarningAction SilentlyContinue

#gets the sets file variables
$date = (Get-Date -UFormat "%Y-%m-%d")
$sub = Get-AzureRMSubscription
$aad = $date + "-" + "AzureAD" + ".json"
$adapps = $date + "-" + "ADApplications" + ".json"


#if Directory paths don't exist, create them, do this for all four azure folders
$pathAzlocal = "C:\Users\user\cloudmonitoring\azure\azurelocal"
If(!(test-path $pathAzlocal))
{
      New-Item -ItemType Directory -Force -Path $pathAzlocal
}

$pathAzpubIP = "C:\Users\user\cloudmonitoring\azure\azurepubiplocal"
If(!(test-path $pathAzpubIP))
{
      New-Item -ItemType Directory -Force -Path $pathAzpubIP
}

$pathAzAADGroups = "C:\Users\user\cloudmonitoring\azure\aadlocal\"
If(!(test-path $pathAzAADGroups))
{
      New-Item -ItemType Directory -Force -Path $pathAzAADGroups
}

$pathAzAADEntApps = "C:\Users\user\cloudmonitoring\azure\adappslocal\"
If(!(test-path $pathAzAADEntApps))
{
      New-Item -ItemType Directory -Force -Path $pathAzAADEntApps
}


ForEach ($vsub in $sub){
#changes the current subscription to the value within the array
Select-AzureRmSubscription $vsub
#sets the file path and file name
#sets the name of the current subscription, this is used in the file name
$currentsubname = (Get-AzureRmContext).Subscription | Select-object name
#the file name for the current subscription, sets file like to json
$filenameazure = $date +"-" + $currentsubname + ".json"
$filenameazureip = $date +"-" + $currentsubname + "ip" + ".json"
#gets a count of all the the resources within a subscription

#displays results 
#Get-azureRMResource

#converts results to json and saves it to file
Get-AzureRmResource | ConvertTo-Json | out-file "C:\Users\user\cloudmonitoring\azure\azurelocal\$fileNameazure"
Get-AzureRmPublicIpAddress | ConvertTo-Json | out-file "C:\Users\user\cloudmonitoring\azure\azurepubiplocal\$filenameazureip"
}

#gets Azure Active Directory app information
Get-AzureRmADGroup | ConvertTo-Json | out-file "C:\Users\user\cloudmonitoring\azure\aadlocal\$aad"
Get-AzureRmADApplication | ConvertTo-Json | out-file "C:\Users\user\cloudmonitoring\azure\adappslocal\$adapps"


#azure only, not AWS
$filepathazure = Get-ChildItem -path C:\Users\user\cloudmonitoring\azure -Directory 

#gets all of the azure local json files 
$filepathazure | ForEach-Object {
$filepathjson = Get-ChildItem -Path C:\Users\user\cloudmonitoring\azure\$_\*.json -Recurse
#if the file is empty, delete it
$filepathjson | where-Object {$_.Length -eq 0kb} | Remove-Item -Force
$filepathjsonafterdelete  = Get-ChildItem -Path C:\Users\user\cloudmonitoring\azure\$_\*.json -Recurse
}

#if the azure file doesn't start with "[" it means that there is only one entry to the file, this saves the content of that file 
$filepathjsonafterdelete | ForEach-Object {
$getfirstlineinfiles = get-content -path  $_ | Select-Object -first 1
$getfirstlineinfiles

$getcontent = Get-Content -path $_

#if the files does only have one entry, add "[" to the beginning of the file and "]" to the end of it
if ($getfirstlineinfiles -ne "[") {  
    $filepathjsonafterdelete 
    $_ | Select-Object name
    Get-Content -path $_
    set-content -path $_ -Value "[" 
    Add-content -path $_ -Value $getcontent 
    Add-content -path $_ -Value "]"
    $_
        
}
}
#logs into aws, uploads azure log files to S3 bucket 
aws s3 sync C:\Users\user\cloudmonitoring\azure\aadlocal s3://s3bucketname/AzureLogs/AzureActiveDirectoryGroups
aws s3 sync C:\Users\user\cloudmonitoring\azure\adappslocal s3://s3bucketname/AzureLogs/AzureEnterpriseApplications
aws s3 sync C:\Users\user\cloudmonitoring\azure\azurelocal s3://s3bucketname/AzureLogs/AzureResources
aws s3 sync C:\Users\user\cloudmonitoring\azure\azurepubiplocal s3://s3bucketname/AzureLogs/AzurePublicIPs

<#Deletes all files in the directory and sub-directory, uncomment when put into production
Get-ChildItem -Path 'C:\Users\user\cloudmonitoring\azure' *.json -Recurse | ForEach-Object { Remove-Item -Path $_.FullName }
#>

