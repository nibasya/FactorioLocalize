$targetpath = "$env:appdata\factorio\mods\"
$shipheader = "ship_ja_"
$locale = "\locale\ja\"

$date = get-date -Format "yyyy_MM_dd"
$destroot = $shipheader + $date

Write-Output "Cleaning up..."
if(Test-Path $destroot){
    Remove-Item -Path $destroot
}
if(Test-Path $($destroot + ".zip")){
    Remove-Item -Path $($destroot + ".zip")
}

Write-Output "Copying files..."
new-item -Path $destroot -ItemType directory | Out-Null

$file = Get-ChildItem $targetpath\aai-* -name
$name = ForEach-Object {$file -split "_"} | Where-Object {$_ -like "aai-*"}

for($i=0;$i -lt $file.Length; $i++){
    if ($file[$i] -like "*.zip"){
        Write-Output "Un-updated mod exists! $($file[$i])"
        exit
    }
    New-Item -Path $($destroot + "\" + $file[$i] + $locale) -ItemType Directory | Out-Null
    Copy-Item -Path $($name[$i] + $locale + "strings.cfg") -Destination $($destroot + "\" + $file[$i] + $locale + "strings.cfg") -Recurse -Force
}

Write-Output "Compressing..."
Compress-Archive -Path $destroot -DestinationPath $($destroot+".zip")

Write-Output "Done."