#! /bin/bash

if [ ! -c /dev/video"$1" ]; then #[]内のスペースも正しく書く必要がある。video$1がない場合
        sudo modprobe -r  v4l2loopback
        sudo modprobe v4l2loopback video_nr="$1"
        sudo chmod 666 /dev/video*
fi


