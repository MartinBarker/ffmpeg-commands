RenderTune/node_modules/ffmpeg-ffprobe-static/ffmpeg -loop 1 -framerate 2 -i ffmpeg-commands/images/img1.png -i ffmpeg-commands/images/img2.png -i "ffmpeg-commands/audio files/song1.mp3"  -i "ffmpeg-commands/audio files/song2.mp3"  -c:a pcm_s32le  -filter_complex concat=n=2:v=0:a=1  -vcodec libx264  -bufsize 3M  -filter:v "scale=w=640:h=638,pad=ceil(iw/2)*2:ceil(ih/2)*2"  -crf 18  -pix_fmt yuv420p  -shortest  -tune stillimage  -t 724 111.mkv 


