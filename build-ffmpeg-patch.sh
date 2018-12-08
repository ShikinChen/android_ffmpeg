#!/bin/bash

#需要编译FFpmeg版本号
FF_VERSION="4.1"
SOURCE="ffmpeg-$FF_VERSION"
SHELL_PATH=`pwd`

FF_PATH=$SHELL_PATH/$SOURCE

 
set -x
patch  -p0 -N --dry-run --silent -f $FF_PATH/libavcodec/aaccoder.c < $SHELL_PATH/ffmpeg_modify_aacoder.patch 1>/dev/null
if [ $? -eq 0 ]; then
patch -p0 -f $FF_PATH/libavcodec/aaccoder.c < $SHELL_PATH/ffmpeg_modify_aacoder.patch
fi
 
patch  -p0 -N --dry-run --silent -f $FF_PATH/libavcodec/hevc_mvs.c < $SHELL_PATH/ffmpeg_modify_hevc_mvs.patch 1>/dev/null
if [ $? -eq 0 ]; then
patch -p0 -f $FF_PATH/libavcodec/hevc_mvs.c < $SHELL_PATH/ffmpeg_modify_hevc_mvs.patch
fi
 
patch  -p0 -N --dry-run --silent -f $FF_PATH/libavcodec/opus_pvq.c < $SHELL_PATH/ffmpeg_modify_opus_pvq.patch 1>/dev/null
if [ $? -eq 0 ]; then
patch -p0 -f $FF_PATH/libavcodec/opus_pvq.c < $SHELL_PATH/ffmpeg_modify_opus_pvq.patch
fi
 
patch  -p0 -N --dry-run --silent -f $FF_PATH/configure < $SHELL_PATH/ffmpeg_modify_configure.patch 1>/dev/null
if [ $? -eq 0 ]; then
patch -p0 -f $FF_PATH/configure < $SHELL_PATH/ffmpeg_modify_configure.patch
fi
set +x
