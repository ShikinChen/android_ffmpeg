#!/bin/sh

SHELL_PATH=$(pwd)

if [ ! -d "$SHELL_PATH/ffmpeg-4.1" ]; then
    echo "下载ffmpeg-4.1"
    curl -O http://ffmpeg.org/releases/ffmpeg-4.1.tar.bz2
fi

if [ ! -d "$SHELL_PATH/x264-snapshot-20181206-2245-stable" ]; then
    echo "下载x264-snapshot-20181206-2245-stable"
    curl -O http://download.videolan.org/x264/snapshots/x264-snapshot-20181206-2245-stable.tar.bz2
fi

if [ ! -d "$SHELL_PATH/fdk-aac-2.0.0" ]; then
    echo "下载fdk-aac-2.0.0"
    curl -O https://jaist.dl.sourceforge.net/project/opencore-amr/fdk-aac/fdk-aac-2.0.0.tar.gz
fi

$SHELL_PATH/tar-file.sh
