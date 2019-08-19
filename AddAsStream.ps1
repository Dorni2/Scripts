$path = Read-Host -Prompt "Enter path for folder"
cd $path
New-Item -ItemType Directory -Path .\Output -ErrorAction Ignore
$ffmpeg = "D:\Dor\ffmpeg-20180708-3a2d21b-win64-static\bin\ffmpeg.exe"
$Stopwatch = [System.Diagnostics.Stopwatch]::StartNew()
$Files = Get-ChildItem -Path . 
$Videos = $Files | where {$_ -like "*.mkv"}
$SrtSubtitles = $Files | where {$_ -like "*.srt"}
foreach  ($vid in $Videos)
{
    $SrtSub = $vid.Name.Replace('.mkv', '.srt')
    $MkvOut = $path + '\Output\' + $vid.Name.Replace('.mkv', '_SubStreamed.mkv')
    &$ffmpeg -i $vid.Name -sub_charenc WINDOWS-1255 -i $SrtSub -map 0:v -map 0:a -c copy -map 1 -c:s:0 srt -metadata:s:s:0 language=heb $MkvOut
    "Elapsed time: " + $Stopwatch.Elapsed.ToString()
    ##&$ffmpeg -i $vid.Name -sub_charenc WINDOWS-1255 -i $SrtSub -c:v copy -c:a copy -c:s copy $MkvOut
}
$Stopwatch.Stop()
$FinishMessage = $Videos.Count.ToString() +  " Videos was rendered in " + $Stopwatch.Elapsed.ToString()
$AvgMessage = "Avreage of " + ($Stopwatch.Elapsed.TotalSeconds / $Videos.Count).ToString() + " seconds per video"
echo $FinishMessage
echo $AvgMessage

