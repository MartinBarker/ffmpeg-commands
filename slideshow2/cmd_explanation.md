# Goal:
Concatenate three audio files into a video with 2 image files used as a slideshow for specific timestamps

# Info:
___ audio timestamps HH:MM:SS____
A1 Sweet Angels (Vocal).flac        00:00:00-00:03:18
A2 Sweet Angels (Acapella).flac     00:03:18-00:06:17
B2 Sweet Angels (Instrumental).flac 00:06:17-00:09:31

___ image timestamps (seconds)____
a-side.png: 0   - 198
b-side.png: 198 - 377
a-side.png: 377 - 571 

# Command Explanation: 
```
C:\Users\martin\Documents\projects\RenderTune\node_modules\ffmpeg-ffprobe-static\ffmpeg.exe
```
Call ffmpeg.exe 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
-i "A1 Sweet Angels (Vocal).flac" \
-i "A2 Sweet Angels (Acapella).flac" \
-i "B2 Sweet Angels (Instrumental).flac \
```
Include input audio files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
-r 2 \
-i a-side.png \
-r 2 \
-i b-side.png 
```
Include input image files
Include `-r 2` before each input img to set the framerate of the input vid to 2fps
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
[4:a][5:a][6:a]concat=n=3:v=0:a=1[a];
```
Concatenate the 3 audio input files as var [a]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Play a-side.png for 198 seconds at 2hz. `x = 198*2 = 396` 
Play b-side.png for 179 seconds at 2hz. `x = 179*2 = 358` 
Play a-side.png for 194 seconds at 2hz. `x = 179*2 = 388` 
```
[0:v]scale=w=640:h=638,setsar=1,loop=396:396[v0];
[1:v]scale=w=640:h=638,setsar=1,loop=358:358[v1];
[0:v]scale=w=640:h=638,setsar=1,loop=388:388[v2];
```
Scale each image to size 640x638
`[0:v]scale=w=640:h=638`

Makes sure that all the concatenated videos have the same SAR (Storage Aspect Ratio), and usually avoids aspect ratio deformation
`setsar=1`


Store the result with temporary name [v0]
`[v0]`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
[v0][v1][v2]concat=n=3:v=1:a=0
```
Concatenate the 3 image/videos (after scaling and looping)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
pad=ceil(iw/2)*2:ceil(ih/2)*2[v]
```
Apply padding to the concatenated videos. Save as var [v]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
-map "[v]" -map "[a]"
```
Map the video [v] to the output video channel, and the audio [a] to the output audio channel
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
-c:a pcm_s32le 
-c:v libx264 
-bufsize 3M 
-crf 18 
-pix_fmt yuv420p 
-tune stillimage
```
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
-t 571
```
Define output duration to be 571 seconds
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Full Command:
```
C:\Users\martin\Documents\projects\RenderTune\node_modules\ffmpeg-ffprobe-static\ffmpeg.exe -i "A1 Sweet Angels (Vocal).flac" -i "A2 Sweet Angels (Acapella).flac" -i "B2 Sweet Angels (Instrumental).flac" -r 2 -i "a-side.png" -r 2 -i "b-side.png" -filter_complex "[4:a][5:a][6:a]concat=n=3:v=0:a=1[a];[0:v]scale=w=640:h=638,setsar=1,loop=396:396[v0];[1:v]scale=w=640:h=638,setsar=1,loop=358:358[v1];[0:v]scale=w=640:h=638,setsar=1,loop=388:388[v2];[v0][v1][v2]concat=n=3:v=1:a=0,pad=ceil(iw/2)*2:ceil(ih/2)*2[v]" -map "[v]" -map "[a]" -c:a pcm_s32le -c:v libx264 -bufsize 3M -crf 18 -pix_fmt yuv420p -tune stillimage -t 571 outputvideo.mkv  
```


C:\Users\martin\Documents\projects\RenderTune\node_modules\ffmpeg-ffprobe-static\ffmpeg.exe 
-i "A1 Sweet Angels (Vocal).flac" 
-i "A2 Sweet Angels (Acapella).flac" 
-i "B2 Sweet Angels (Instrumental).flac" 
-r 2 -i "a-side.png" 
-r 2 -i "b-side.png" 
-filter_complex "[4:a][5:a][6:a]concat=n=3:v=0:a=1[a];[0:v]scale=w=640:h=638,setsar=1,loop=396:396[v0];[1:v]scale=w=640:h=638,setsar=1,loop=358:358[v1];[0:v]scale=w=640:h=638,setsar=1,loop=388:388[v2];[v0][v1][v2]concat=n=3:v=1:a=0,pad=ceil(iw/2)*2:ceil(ih/2)*2[v]" 
-map "[v]" 
-map "[a]" 
-c:a pcm_s32le 
-c:v libx264 
-bufsize 3M 
-crf 18 
-pix_fmt yuv420p 
-tune stillimage 
-t 571 outputvideo.mkv  



