#extracts compressed .json.gz files from aws so it can be opened as .json, needs 7zip installed
aws s3 sync s3://configs3bucket/ C:\Users\user\downloadlocation

set-alias sz "$env:ProgramFiles\7-Zip\7z.exe"
$filePath = "C:\Users\user\downloadlocation1" 
$gz = Get-ChildItem -Recurse -Path $filePath | Where-Object { $_.Extension -eq ".gz" } 
foreach ($file in $gz) { 
                    $name = $file.name 
                    $directory = $file.DirectoryName 
                    $directory
                    $zipfile = $name.Replace(".json.gz",".json") 
                    sz e "$directory\$file" -o"$directory\$zipfilename"      
                }
Get-ChildItem -Path "C:\Users\user\downloadlocation1" -Recurse -File | Move-Item -Destination "C:\Users\user\downloadlocation2"
Get-ChildItem -Path "C:\Users\user\downloadlocation2\" *.gz | foreach { Remove-Item -Path $_.FullName }
Remove-Item –path "C:\Users\user\downloadlocation1" -include *.gz –recurse
Remove-Item –path "C:\Users\user\downloadlocation2\" -include *json.gz #–recurse