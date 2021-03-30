aws s3 sync s3://s3-grp-br-resourcecount/ C:\Users\hbrass\awssyncfiles
set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
$filePath = "C:\Users\hbrass\awssyncfiles" 
$gz = Get-ChildItem -Recurse -Path $filePath | Where-Object { $_.Extension -eq ".gz" } 
foreach ($file in $gz) { 
                    $name = $file.name 
                    $directory = $file.DirectoryName 
                    $directory
                    $zipfile = $name.Replace(".json.gz",".json") 
                    sz e "$directory\$file" -o"$directory\$zipfilename"      
                }
Get-ChildItem -Path "C:\Users\hbrass\awssyncfiles" -Recurse -File | Move-Item -Destination "C:\Users\hbrass\awslocal\"
Get-ChildItem -Path "C:\Users\hbrass\awslocal\" *.gz | foreach { Remove-Item -Path $_.FullName }
#Remove-Item –path "C:\Users\hbrass\awssyncfiles" -include *.gz –recurse
#Remove-Item –path "C:\Users\hbrass\awslocal\" -include *json.gz #–recurse