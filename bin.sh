#!/bin/bash

echo "                                                                              "                                    ....                                            
echo "                          .o0WMMMMNd                                          "
echo "                        .OMMMMMMMMMM0.                                        "
echo "                        lWMMMMMMMMMMMX.  l0KXKk:                              "
echo "                         .lNMMMMMMMMMMK. 'NMMMMMK.                            "
echo "                           .xWMMMMMMMMMk  oMMMMMMN'                           "
echo "                             .xWMMMMMMMMc .NMMMMMMK. .kd:                     "
echo "                               ,XMMMMMMMX. dMMMMMMM0. oMM0.                   "
echo "                                .xMMMMMMMc ,MMMMMMMMx  0MMX,                  "
echo "                                  lMMMMMMd  KMMMMMMMM' ;MMMN,                 "
echo "                                   dMMMMMx  .kMMMMMMMl  XMMMN.                "
echo "                                    KMMMMd    oMMMMMMk  kMMMMO                "
echo "                                    ,WMMM:     xMMMMMO  dMMMMM,               "
echo "                                     kMMX.      OMMMMk  xMMMMMk               "
echo "                                     :MW;       .XMMMd  OMMMMMX.              "
echo "                                     .Mo         lMMM;  :MMMMMW.              "
echo "                                     .d          .WMK    dMMMMW.              "
echo "                                   .::            KN.    .XMMMX               "
echo "                               .;o0WX.            d'      lMMMo               "
echo "               ..........',cokXMMMMX.                     .NMN.               "
echo "              .NMMMMMMMMMMMMMMMMMMO.    Cyber Claws 2018   OMl                "
echo "               KMMMMMMMMMMMMMMMXo.                         ok                 "
echo "               ,WMMMMMMMMMMW0d,                            .                  "
echo "                'ONMWX0ko:'.                                                  "
echo "                   .                                                          "
echo ""
current_date_time="`date "+%Y-%m-%d %H:%M:%S"`";
echo "Starting ${current_date_time}"

dir="."
length="10"
fileformat="wav"
remove="false"

print_usage() {
  echo "Usage: chop-shop -dlf [option] -rh"
  echo ""
  echo ""
  echo "please ensure you have the latest version of:"
  echo "0) ffmpeg"
  echo "1) sox"
  echo "2) ffprobe"
  echo "3) lame"
  echo ""
  echo ""
  echo "Options:"
  echo ""
  echo "h - Print this help menu."
  echo "l - Length in seconds of each choped or padded sound sample. Default 10 seconds"
  echo "d - Directory will the with audio files to be chopped or padded."
  echo "f - The file extention of the files your are padding or chopping, default is wav"
  echo "r - Remove original file"
  echo ""
}

while getopts 'd:l:f:hr' flag; do
  case "${flag}" in
    d) dir="${OPTARG}" ;;
    l) length="${OPTARG}" ;;
    f) fileformat="${OPTARG}" ;;
    h) print_usage 
       exit 1;;
    r) remove="true" ;;
    *) print_usage
       exit 1 ;;
  esac
done

echo "Reading files..." 
find "${dir}" -type f | grep ".${fileformat}" > file-hierarchy.txt
echo "Reading files..."
echo "Processing..."

while read filepath; do
    audioduration=`ffprobe -v error -show_entries format=duration -of default=noprint_wrappers=1:nokey=1 "${filepath}"`;
    temp=${audioduration%.*};
    echo ${temp};
    if [ $temp -lt $length ]; then
        echo "Audio file ${filepath} duration shorter than ${length}" ;
        ffmpeg -y -i "${filepath}" -acodec pcm_u8 -ar 44100 "${filepath} temp.wav";
        rm -f ${filepath};
        mv "${filepath} temp.wav" ${filepath};
        echo "${length} Hello world ${temp}";
        difference=`expr $length - $temp`;
        silence=`sox -n -r 44100 -c 2 silence.wav trim 0.0 ${difference}`;
        sox silence.wav ${filepath} "${filepath} processed.${fileformat}";
        rm -f silence.wav;
    else
        echo "Audio file ${filepath} duration longer than ${length}";
        ffmpeg -y -ss 0 -t ${length} -i "${filepath}" "${filepath} processed.${fileformat}";
        if [ $remove = true ]; then
            rm -f "${filepath}";
        fi
    fi
done < file-hierarchy.txt

rm -f file-hierarchy.txt
current_date_time="`date "+%Y-%m-%d %H:%M:%S"`";
echo "Finished ${current_date_time}"

