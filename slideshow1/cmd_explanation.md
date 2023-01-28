# Goal:
Concatenate three audio files into a video, with 4 image files used as a slideshow for specific timestamps
Play each image for exactly 252.5 seconds
252.5 seconds per img for 4 images = `252.5*4=1010 seconds`

# Info:
___ audio timestamps HH:MM:SS____
song1.mp3 00:00:00-00:06:23
song2.mp3 00:06:23-00:12:04
song3.wav 00:12:04-00:16:50

___ image timestamps (seconds)____
img1: 0     - 252.5
img2: 252.5 - 505
img3: 505   - 757.5
img4: 757.5 -  252.5

# Command Explanation: 
```
C:\Users\martin\Documents\projects\RenderTune\node_modules\ffmpeg-ffprobe-static\ffmpeg.exe
```
Call ffmpeg.exe 
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
-i song1.mp3 \
-i song2.mp3 \
-i song3.wav \
```
Include input audio files
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
-r 2 \
-i img1.png \
-r 2 \
-i img2.png \
-r 2 \
-i img3.png \
-r 2 \
-i img4.png \
```
Include input image files
Include `-r 2` before each input img to set the framerate of the input vid to 2fps
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
[4:a][5:a][6:a]concat=n=3:v=0:a=1[a];
```
Concatenate the 3 audio input files as var [a]
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
Play each img for 252.5 seconds at 2hz.
Formula: `x=252.5*2` solve for x. `x=505`
```
[0:v]scale=w=640:h=638,setsar=1,loop=505:505[v0];
[1:v]scale=w=640:h=638,setsar=1,loop=505:505[v1];
[2:v]scale=w=640:h=638,setsar=1,loop=505:505[v2];
[3:v]scale=w=640:h=638,setsar=1,loop=505:505[v3];
```
Scale each image to size 640x638
`[0:v]scale=w=640:h=638`

Makes sure that all the concatenated videos have the same SAR (Storage Aspect Ratio), and usually avoids aspect ratio deformation
`setsar=1`

Use loop filter for repeating each image 505 times (505 times at 2Hz applies 252.5 seconds) [505/2=252.5]
The first 505 is the number of loops, second 505 is number of frames in each loop (they should have the same value)
`loop=505:505`

Store the result with temporary name [v0]
`[v0]`
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
```
[v0][v1][v2][v3]concat=n=4:v=1:a=0
```
Concatenate the 4 videos (after scaling and looping)
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
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
-t 1010
```
Define output duration to be 1010 seconds
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

# Full Command:
```
ffmpeg -r 2 -i img1.png -r 2 -i img2.png -r 2 -i img3.png -r 2 -i img4.png -i song1.mp3 -i song2.mp3 -i song3.wav -filter_complex "[4:a][5:a][6:a]concat=n=3:v=0:a=1[a];[0:v]scale=w=640:h=638,setsar=1,loop=505:505[v0];[1:v]scale=w=640:h=638,setsar=1,loop=505:505[v1];[2:v]scale=w=640:h=638,setsar=1,loop=505:505[v2];[3:v]scale=w=640:h=638,setsar=1,loop=505:505[v3];[v0][v1][v2][v3]concat=n=4:v=1:a=0,pad=ceil(iw/2)*2:ceil(ih/2)*2[v]" -map "[v]" -map "[a]" -c:a pcm_s32le -c:v libx264 -bufsize 3M -crf 18 -pix_fmt yuv420p  -tune stillimage -t 1010 outputvideo.mkv
```



