const { spawn } = require('child_process');
const musicMetadata = require('music-metadata-browser');

function createFilterComplexString(audioInputs, imageInputs, resolutionWidth, resolutionHeight){
    /*
    - Return a string like this: 
        [0:a]concat=n=1:v=0:a=1[a];[1:v]scale=w=1920:h=1937,setsar=1,loop=2102:2102[v0];[2:v]scale=w=1920:h=1937,setsar=1,loop=2102:2102[v1];[v0][v1]concat=n=2:v=1:a=0,pad=ceil(iw/2)*2:ceil(ih/2)*2[v]
    - Explanation:
        - concat audio
        [0:a]concat=n=1:v=0:a=1[a];
        - for each video, determine how long it should play 
        [1:v]scale=w=1920:h=1937,setsar=1,loop=2102:2102[v0];
        [2:v]scale=w=1920:h=1937,setsar=1,loop=2102:2102[v1];
    
        [v0][v1]concat=n=2:v=1:a=0,pad=ceil(iw/2)*2:ceil(ih/2)*2[v]
    
    */
}

// list of input options
const audioCodec = 'aac';
const videoCodec = 'libx264';
const resolution = '1920x1080';
const filter = 'scale=1280:-2';

const audioInputs = [
    "E:\\martinradio\\rips\\vinyl\\unknownrecord1\\untitled.flac"
]

const imageInputs = [
    "E:\\martinradio\\rips\\vinyl\\unknownrecord1\\front.png",
    "E:\\martinradio\\rips\\vinyl\\unknownrecord1\\back.png"
]

const inputs = [...audioInputs, ...imageInputs]
console.log('inputs=',inputs)

const output = 'E:\\martinradio\\rips\\vinyl\\unknownrecord1\\output.mkv';
const ffmpegPath = '/mnt/c/Users/marti/Documents/projects/rendertune2/node_modules/ffmpeg-ffprobe-static/ffmpeg.exe';


// create the ffmpeg command 
const args = []
//add inputs 
inputs.forEach(element => {
    console.log('adding ',element)
    args.push('-r')
    args.push('2')
    args.push('-i')
    args.push(`${element}`)
});
//get audio file(s) total length/duration 


//create filterComplexString
var filterComplexString = createFilterComplexString(audioInputs, imageInputs, resolutionWidth='1920', resolutionHeight='1080')
/*
const args = [
    '-r', '2', '-i', "E:\\martinradio\\rips\\vinyl\\unknownrecord1\\untitled.flac",
    '-r', '2', '-i', "E:\\martinradio\\rips\\vinyl\\unknownrecord1\\front.png",
    '-r', '2', '-i', "E:\\martinradio\\rips\\vinyl\\unknownrecord1\\back.png",
    '-filter_complex', "[0:a]concat=n=1:v=0:a=1[a];[1:v]scale=w=1920:h=1937,setsar=1,loop=2102:2102[v0];[2:v]scale=w=1920:h=1937,setsar=1,loop=2102:2102[v1];[v0][v1]concat=n=2:v=1:a=0,pad=ceil(iw/2)*2:ceil(ih/2)*2[v]",
    `-map`, "[v]",
    `-map`, "[a]",
    '-c:a', 'pcm_s32le',
    '-c:v', 'libx264',
    '-bufsize', '3M',
    '-crf', '18',
    '-pix_fmt', 'yuv420p',
    '-tune', 'stillimage',
    '-t', '2102',
    output,
];
*/

// spawn the ffmpeg process
const ffmpeg = spawn(ffmpegPath, args);
// track the progress of the ffmpeg process
let duration = null;
let start = null;
let lastTime = null;
ffmpeg.stderr.on('data', (data) => {
    const str = data.toString();
    const timeMatch = str.match(/Duration: (\d{2}):(\d{2}):(\d{2})/);
    if (timeMatch) {
        const hours = parseInt(timeMatch[1], 10);
        const minutes = parseInt(timeMatch[2], 10);
        const seconds = parseInt(timeMatch[3], 10);
        duration = hours * 3600 + minutes * 60 + seconds;
        start = Date.now();
    }
    const timeMatch2 = str.match(/time=(\d{2}):(\d{2}):(\d{2})/);
    if (timeMatch2) {
        const hours = parseInt(timeMatch2[1], 10);
        const minutes = parseInt(timeMatch2[2], 10);
        const seconds = parseInt(timeMatch2[3], 10);
        const currentTime = hours * 3600 + minutes * 60 + seconds;
        const percent = Math.floor((currentTime / duration) * 100);
        const elapsedTime = Date.now() - start;
        const remainingTime = Math.floor((elapsedTime / (percent / 100)) / 60000);
        if (percent && percent !== lastTime) {
            console.log(`Progress: ${percent}% (${remainingTime} minutes remaining)`);
            lastTime = percent;
        }
    }
});

// handle errors and exit codes
ffmpeg.on('error', (err) => {
    console.error('Error:', err);
});

ffmpeg.on('close', (code) => {
    if (code !== 0) {
        console.error(`Exited with code ${code}`);
    } else {
        console.log('Done!');
    }
});
