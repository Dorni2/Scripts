$path = Read-Host -Prompt "Enter path for folder"
cd $path
New-Item -ItemType Directory -Path .\Output -ErrorAction Ignore
$ffmpeg = "D:\Dor\ffmpeg-20180708-3a2d21b-win64-static\bin\ffmpeg.exe"
$Files = Get-ChildItem -Path . 
$Videos = $Files | where {$_ -like "*.mkv"}
$SrtSubtitles = $Files | where {$_ -like "*.srt"}
$SrtSubtitles | ForEach-Object {&$ffmpeg -i $_.FullName $_.FullName.Replace('srt','ass')}
$AssSubtitles = Get-ChildItem -Path . | where {$_ -like "*.ass"}
foreach  ($vid in $Videos)
{
    $AssSub = $vid.Name.Replace('.mkv', '.ass')
    $MkvOut = $path + '\Output\' + $vid.Name.Replace('.mkv', '_subbed.mkv')
    &$ffmpeg -i $vid.Name -vf ass=$AssSub $MkvOut
}