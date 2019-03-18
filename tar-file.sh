#!/bin/sh

SHELL_PATH=$(pwd)

echo "解压ffmpeg-4.1.tar.bz2"
tar zxvf $SHELL_PATH/ffmpeg-4.1.tar.bz2
echo "解压x264-snapshot-20181206-2245-stable.tar.bz2"
tar zxvf $SHELL_PATH/x264-snapshot-20181206-2245-stable.tar.bz2
echo "解压fdk-aac-2.0.0.tar.gz"
tar zxvf $SHELL_PATH/fdk-aac-2.0.0.tar.gz
echo "解压lame-3.100.tar.gz"
tar zxvf $SHELL_PATH/lame-3.100.tar.gz