#! /bin/bash

if [ ! -c /dev/video"$1" ]; then #[]内のスペースも正しく書く必要がある。video$1がない場合
        sudo modprobe -r  v4l2loopback
        sudo modprobe v4l2loopback video_nr="$1"
        sudo chmod 666 /dev/video*
        youtube-dl "$2" -o - | ffmpeg -re -i - -r 30 -s 1280x720 -vcodec rawvideo -f v4l2 /dev/video"$1"
else #video$1がすでにある場合
        youtube-dl "$2" -o - | ffmpeg -re -i - -r 30 -s 1280x720 -vcodec rawvideo -f v4l2 /dev/video"$1"
fi


