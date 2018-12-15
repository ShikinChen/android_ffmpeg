#!/bin/bash

#需要编译FFpmeg版本号
FF_VERSION="4.1"
SOURCE="ffmpeg-$FF_VERSION"
SHELL_PATH=$(pwd)
FF_PATH=$SHELL_PATH/$SOURCE
#输出路径
PREFIX=$SHELL_PATH/ffmpeg_android

x264=$SHELL_PATH/x264_android
aac=$SHELL_PATH/aac_android

# echo "aac:$aac/${ARCH}/"

FF_CONFIGURE_FLAGS="--enable-static --disable-shared --enable-pic --enable-postproc --disable-stripping"

#若使用android-ndk-r15c及以上NDK需要打此补丁(修改FFmepg与NDK代码冲突)
sh $SHELL_PATH/build-ffmpeg-patch.sh $FF_PATH

cd $FF_PATH
export TMPDIR=$FF_PATH/tmpdir
mkdir $TMPDIR

PREFIX_ARCH=$PREFIX/$ABI
rm -rf $PREFIX_ARCH

FF_EXTRA_CONFIGURE_FLAGS="${EXTRA_CONFIGURE_FLAGS} --enable-libx264 --enable-encoder=libx264 --enable-libfdk-aac --enable-encoder=libfdk-aac --enable-nonfree"
FF_EXTRA_CFLAGS="${EXTRA_CFLAGS} -I$x264/${ABI}/include  -I$aac/${ABI}/include"
FF_LDFLAGS="-L$x264/${ABI}/lib  -L$aac/${ABI}/lib"

FF_EXTRA_CONFIGURE_FLAGS="${EXTRA_CONFIGURE_FLAGS}  --enable-libfdk-aac --enable-encoder=libfdk-aac --enable-nonfree"
FF_EXTRA_CFLAGS="${EXTRA_CFLAGS} -I$aac/${ABI}/include"
FF_LDFLAGS="-L$aac/${ABI}/lib"

echo "PREFIX_ARCH:${PREFIX_ARCH}"
echo "FF_EXTRA_CONFIGURE_FLAGS:${FF_EXTRA_CONFIGURE_FLAGS}"
echo "FF_EXTRA_CFLAGS:${FF_EXTRA_CFLAGS}"
echo "FF_LDFLAGS:${FF_LDFLAGS}"

FF_CFLAGS="-U_FILE_OFFSET_BITS -O3 -pipe -Wall -ffast-math -fstrict-aliasing -Werror=strict-aliasing -Wno-psabi -Wa,--noexecstack -DANDROID -D__ANDROID_API__=$ANDROID_API_VERSION"

CC=$CC $FF_PATH/configure \
	--prefix=$PREFIX_ARCH \
	--sysroot=$SYSROOT \
	--target-os=android \
	--arch=$ARCH \
	--cross-prefix=$CROSS_PREFIX \
	--enable-cross-compile \
	--disable-runtime-cpudetect \
	--disable-doc \
	--disable-debug \
	--disable-ffmpeg \
	--disable-ffprobe \
	--enable-gpl \
	--disable-ffplay \
	--disable-symver \
	--enable-small \
	$FF_CONFIGURE_FLAGS \
	$FF_EXTRA_CONFIGURE_FLAGS \
	--extra-cflags="$FF_EXTRA_CFLAGS $FF_CFLAGS" \
	--extra-ldflags="$FF_LDFLAGS"

export CC
make clean
make install

rm -rf "$PREFIX_ARCH/share"
rm -rf "$PREFIX_ARCH/lib/pkgconfig"

echo "Android FFmpeg bulid success!"
