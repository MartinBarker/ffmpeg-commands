ffmpeg -r 2 
-i "C:\Users\marti\Documents\projects\ffmpeg-commands\ffmpeg_slideshow_padding\10. Deejay Punk-Roc - Knock em All The Way Out.aiff" -r 2 
-i "C:\Users\marti\Documents\projects\ffmpeg-commands\ffmpeg_slideshow_padding\11. Deejay Punk-Roc - Spring Break.aiff" -r 2 
-i "C:\Users\marti\Documents\projects\ffmpeg-commands\ffmpeg_slideshow_padding\12. Deejay Punk-Roc - Fat Gold Chain.aiff" -r 2 
-i "C:\Users\marti\Documents\projects\ffmpeg-commands\ffmpeg_slideshow_padding\1_front.jpg" -r 2 
-i "C:\Users\marti\Documents\projects\ffmpeg-commands\ffmpeg_slideshow_padding\2_back.jpg" -r 2 
-i "C:\Users\marti\Documents\projects\ffmpeg-commands\ffmpeg_slideshow_padding\3_cd.jpg" 

-filter_complex "
[0:a][1:a][2:a]concat=n=3:v=0:a=1[a];

[3:v]scale=w=1920:h=1898,setsar=1,loop=580.03:580.03[v3];

[4:v]
scale=1920:1898:force_original_aspect_ratio=decrease,
pad=1920:1898:-1:-1,setsar=1,loop=580.03:580.03[v4];

[5:v]scale=w=1920:h=1898,setsar=1,loop=580.03:580.03[v5];

[v3][v4][v5]concat=n=3:v=1:a=0,pad=ceil(iw/2)*2:ceil(ih/2)*2[v]"

 -map "[v]" -map "[a]" -c:a pcm_s32le -c:v libx264 -bufsize 3M -crf 18 -pix_fmt yuv420p -tune stillimage -t 870.04 "C:\Users\marti\Documents\projects\ffmpeg-commands\ffmpeg_slideshow_padding\slidet.mkv"
