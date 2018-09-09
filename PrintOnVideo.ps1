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











##$AssSubtitles = $Srtubtitles | ForEach-Object 
##{
##Write-Host $_.FullName;
##$_.FullName.Replace('srt','ass');
##}
##foreach ($itm in $SrtSubtitles) 
##{
##    $AssSubtitles.ad
##    $AssSubtitles.Add($itm.FullName.Replace('srt','ass'))
##}


##$Videos | ForEach-Object {&$ffmpeg -i $_.FullName -vf ass=$_.FullName.Replace('mkv','ass') $_.FullName.Replace('.mkv', '_subbed.mkv')}

#foreach  ($vid in $Videos)
#{
#    $vid
#    $AssSub = $vid.FullName.Replace('mkv','ass')
#    $MkvOut = $vid.FullName.Replace('.mkv', '_subbed.mkv')
#    &$ffmpeg -i $vid.FullName -vf ass=$AssSub $MkvOut
#}

##trying to escape



#&$ffmpeg -i D:\Dor\Tv-Shows\s11\Two.and.a.Half.Men.S11E01.720p.5.1Ch.Web-DL.ReEnc-DeeJayAhmed.mkv -vf ass=D:\Dor\Tv-Shows\s11\Two.and.a.Half.Men.S11E01.720p.5.1Ch.Web-DL.ReEnc-DeeJayAhmed.ass D:\Dor\Tv-Shows\s11\Two.and.a.Half.Men.S11E01.720p.5.1Ch.Web-DL.ReEnc-DeeJayAhmed_sub.mkv


