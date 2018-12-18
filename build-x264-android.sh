#!/bin/bash

X264_VERSION="snapshot-20181206-2245"
SOURCE="x264-$X264_VERSION"
SHELL_PATH=$(pwd)
X264_PATH=$SHELL_PATH/$SOURCE
#输出路径
PREFIX=$SHELL_PATH/x264_android

cd $X264_PATH
X264_CONFIGURE_FLAGS="--enable-static  --disable-shared --enable-pic --disable-cli"

PREFIX_ARCH=$PREFIX/$ABI
rm -rf $PREFIX_ARCH

X264_CFLAGS="$CFLAGS -U_FILE_OFFSET_BITS -DANDROID"
AS_TMP=$AS
export AS=$CC

echo "X264_CFLAGS:$X264_CFLAGS"
CC=$CC $X264_PATH/configure \
	--prefix=$PREFIX_ARCH \
	--host=$TOOLCHAINS_PREFIX \
	$X264_CONFIGURE_FLAGS \
	$EXTRA_CONFIGURE_FLAGS \
	--extra-cflags="$EXTRA_CFLAGS $X264_CFLAGS" \
	--extra-ldflags=""

export CC
make clean
make install

rm -rf "$PREFIX_ARCH/lib/pkgconfig"
if [[ $X264_CONFIGURE_FLAGS == *--enable-shared* ]]; then
	# mv $PREFIX_ARCH/lib/libx264.so.* $PREFIX_ARCH/lib/libx264.so
fi
export AS=$AS_TMP
echo "Android x264 bulid success!"
