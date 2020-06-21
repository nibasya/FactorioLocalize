$targetpath = "$env:appdata\factorio\mods\"
$destpath = "\locale\ja"
$destfile = "\strings.cfg"

$file = Get-ChildItem $targetpath\aai-* -name
$name = ForEach-Object {$file -split "_"} | Where-Object {$_ -like "aai-*"}
for($i=0;$i -lt $file.Length; $i++){
    $src = $name[$i] + $destpath + $destfile
    $dest = $targetpath + $file[$i] + $destpath + $destfile
    if(Test-Path $src){
        # update only existing folders
        if(!(Test-Path $dest)){
            # dest does not exists!
            Copy-Item $($name[$i]+$destpath) -Destination $($targetpath+$file[$i]+$destpath) -Recurse
            Write-Output "Generated $dest"
        }
        $result = Compare-Object -ReferenceObject (Get-Content -Path $dest) -DifferenceObject (Get-Content -Path $src)
        if ($result.length -ne 0){
            #The file has a change, so update
            Copy-Item $src -Destination $dest -Force
            Write-Output "Updated $($name[$i])"
        }
    }
}