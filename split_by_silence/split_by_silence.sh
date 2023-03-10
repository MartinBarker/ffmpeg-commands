# need to run: $ apt-get install bc
# ./split_by_silence.sh "full_lowq.flac" %03d_output.flac
#IN=$1
#OUT=$2

OUT="%03d_output.mp3"
IN="/mnt/e/martinradio/rips/vinyl/WIP/musical war singing francine/full.mp3"
OUTPUT_LOCATION="/mnt/e/martinradio/rips/vinyl/WIP/musical war singing francine/"

true ${SD_PARAMS:="-24dB"};
true ${MIN_FRAGMENT_DURATION:="5"};
export MIN_FRAGMENT_DURATION
if [ -z "$OUT" ]; then
    echo "Usage: split_by_silence.sh full.mp3 output_template_%03d.mp3"
    echo "Depends on FFmpeg, Bash, Awk, Perl 5. Not tested on Mac or Windows."
    echo ""
    echo "Environment variables (with their current values):"
    echo "    SD_PARAMS=$SD_PARAMS       Parameters for FFmpeg's silencedetect filter: noise tolerance and minimal silence duration"
    echo "    MIN_FRAGMENT_DURATION=$MIN_FRAGMENT_DURATION    Minimal fragment duration"
    exit 1
fi
#
# get comma separated list of split points (use ffmpeg to determine points where audio is at SD_PARAMS [-18db] )
#

echo "_______________________"
echo "Determining split points..." >& 2
SPLITS=$(
    ffmpeg -v warning -i "$IN" -af silencedetect="$SD_PARAMS",ametadata=mode=print:file=-:key=lavfi.silence_start -vn -sn  -f s16le  -y /dev/null \
    | grep lavfi.silence_start= \
    | cut -f 2-2 -d= \
    | perl -ne '
        our $prev;
        INIT { $prev = 0.0; }
        chomp;
        if (($_ - $prev) >= $ENV{MIN_FRAGMENT_DURATION}) {
            print "$_,";
            $prev = $_;
        }
    ' \
    | sed 's!,$!!'
)
echo "SPLITS= $SPLITS"



#
# Print how many tracks should be exported
#
res="${SPLITS//[^,]}"
CHARCOUNT="${#res}"
num=$((CHARCOUNT + 2))
echo "Exporting $num tracks"
echo "_______________________"

#
# Split audio into individual tracks
#
current_directory=$(pwd)

cd "$OUTPUT_LOCATION"

echo "Running ffmpeg command: "

ffmpeg -i "$IN" -c copy -map 0 -f segment -segment_times "$SPLITS" "$OUT"
#ffmpeg -i "full_lowq.flac" -c copy -map 0 -f segment -segment_times "302.825,552.017" "%03d_output.flac"


echo "Done."

cd $current_directory

echo "running flac command"
# check flac file intrgrity