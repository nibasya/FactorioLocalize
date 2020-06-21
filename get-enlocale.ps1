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
  $src = $targetpath + $file[$i] + $targetfile
  $dest = $name[$i] + $targetfile
  $result = Compare-Object -ReferenceObject (Get-Content -Path $dest) -DifferenceObject (Get-Content -Path $src)
  if ($result.length -ne 0){
    #The file has a change, so update
    Copy-Item $src -Destination $dest -Recurse -Force
    Write-Output "Updated $($name[$i])"
  }
}