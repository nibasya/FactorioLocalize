$targetpath = "$env:appdata\factorio\mods\"
$targetfile = "\locale\en\strings.cfg"

$file = Get-ChildItem $targetpath\aai-* -name
$name = ForEach-Object {$file -split "_"} | Where-Object {$_ -like "aai-*"}
for($i=0;$i -lt $file.Length; $i++){
  if(!(Test-Path $name[$i])){
    #folder does not exists, so create folders
    $src = $targetpath + $file[$i] +"\locale"
    $dest = $name[$i] + "\locale"
    Copy-Item $src -Destination $dest -Recurse
    Write-Output "Generated $($name[$i])"
  }
  if ($file[$i] -like "*.zip"){
    Expand-Archive -Path $($targetpath+$file[$i]) -DestinationPath $targetpath
    Remove-Item -Path $($targetpath+$file[$i])
    Write-Output "Expanded $($file[$i])"
    $tmp = $file[$i] -split ".zip"
    $file[$i] = $tmp[0]
  }
  $src = $targetpath + $file[$i] + $targetfile
  $dest = $name[$i] + $targetfile
  $result = Compare-Object -ReferenceObject (Get-Content -Path $dest) -DifferenceObject (Get-Content -Path $src)
  if ($result.length -ne 0){
    #The file has a change, so update
    Copy-Item $src -Destination $dest -Recurse -Force
    Write-Output "Updated $($name[$i])"
  }
}