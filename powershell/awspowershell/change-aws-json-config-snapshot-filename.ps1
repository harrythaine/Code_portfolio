#changes the name of downloaded config snapshot to a human readable name 
For ($i=0; $i -le 1000; $i++) {
$awsfilefiletoreplace = get-childitem -path "C:\Users\username\cloudmonitoring\test\*.json" -Force
if ($awsfilefiletoreplace.Name -match "ACCOUNT_ID") {
        $awsfilefiletoreplace | ForEach-Object  {
        rename-item $_ $_.Name.Replace("ACCOUNT_ID", "THE NAME YOU WANT THE FILE TO HAVE") -force
        
    }
}

elseif ($awsfilefiletoreplace.FullName -match "Config_") {
        $awsfilefiletoreplace | ForEach-Object  { 
        rename-item $_ $_.Name.Replace("Config_", "") -force 
        
}
}
elseif ($awsfilefiletoreplace.Name -match "ConfigSnapshot_") {
        $awsfilefiletoreplace| ForEach-Object  { 
        rename-item $_ $_.Name.Replace("ConfigSnapshot_", "") -Force
    }
}
else {
    break
}
}


$awsfilefiletoreplace = get-childitem -path "C:\Users\username\cloudmonitoring\test\"
if ($awsfilefiletoreplace.Name -match ".json"){
write-output $awsfilefiletoreplace

$awsfilefiletoreplace | rename-item -newname {
    $_.name.substring(0,$_.name.length-20) 
    } 
}
else {
$awsfilefiletoreplace = get-childitem -path "C:\Users\username\cloudmonitoring\test\"
$awsfilefiletoreplace| ForEach-Object  { 
    rename-item $_ $_.Name.Replace("$_", "$_.json") -Force
    }
}