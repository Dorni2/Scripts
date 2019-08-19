$path = Read-Host -Prompt "Enter path for folder"
cd $path
New-Item -ItemType Directory -Path .\Output -ErrorAction Ignore
$ffmpeg = "D:\Dor\ffmpeg-20180708-3a2d21b-win64-static\bin\ffmpeg.exe"
$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$Files = Get-ChildItem -Path . 
$Videos = $Files | where {$_ -like "*.mkv"}
## Change the format here -------------^---------
foreach  ($vid in $Videos)
{
    $output = cmd /c $ffmpeg -i $vid.Name 2`>`&1
    $allStreams = $output | where {$_ -like "*stream*"}
    $maxStream = $allStreams[$allStreams.Count - 1].split(":")[1].split("(")[0]  -as [int]
    $hebSub = $output | where {$_ -like "*heb*"}
    $streamIndex = $hebSub.Split(":")[0].split("#")[1]
    $inStreamIndex = $hebSub.Split(":")[1].split("(heb)")[0]
    $inStreamIndex = $inStreamIndex - 2
    $subString = $streamIndex + ":s:" + $inStreamIndex
    $MkvOut = $path + '\Output\' + $vid.Name.Replace('.mkv', '_SubStreamed.mkv')
    ## Change the format here --------------------------^---------
        ## output format cannot be changed - has to be mkv------------------^----------
    &$ffmpeg -i $vid.Name -c copy -map 0:v -c copy -map 0:a -c copy -map $subString $MkvOut
    "Elapsed time: " + $Stopwatch.Elapsed.ToString()
}
$Stopwatch.Stop()
$FinishMessage = $Videos.Count.ToString() +  " Videos was rendered in " + $Stopwatch.Elapsed.ToString()
$AvgMessage = "Avreage of " + ($Stopwatch.Elapsed.TotalSeconds / $Videos.Count).ToString() + " seconds per video"
echo $FinishMessage
echo $AvgMessage