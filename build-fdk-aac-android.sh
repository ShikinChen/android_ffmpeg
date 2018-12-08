#!/bin/bash

AAC_VERSION="2.0.0"
SOURCE="fdk-aac-$AAC_VERSION"
SHELL_PATH=$(pwd)
AAC_PATH=$SHELL_PATH/$SOURCE
#输出路径
PREFIX=$SHELL_PATH/aac_android

AAC_CONFIGURE_FLAGS="--enable-static --disable-shared --enable-strip --enable-pic --target=android"

cd $AAC_PATH

PREFIX_ARCH=$PREFIX/$ABI
rm -rf $PREFIX_ARCH

echo "PREFIX_ARCH:$PREFIX_ARCH"

FF_CFLAGS="-U_FILE_OFFSET_BITS -DANDROID"

export CFLAGS="$CFLAGS $EXTRA_CFLAGS $FF_CFLAGS"
echo "CFLAGS:$CFLAGS"
# echo "TOOLCHAINS_PREFIX:$TOOLCHAINS_PREFIX"

CC=$CC $AAC_PATH/configure \
	--prefix=$PREFIX_ARCH \
	--host=$TOOLCHAINS_PREFIX \
	$AAC_CONFIGURE_FLAGS \
	$EXTRA_CONFIGURE_FLAGS

export CC
make clean
make install

rm -rf "$PREFIX_ARCH/lib/pkgconfig"
if [[ $AAC_CONFIGURE_FLAGS == *--enable-shared* ]]; then
	mv $PREFIX_ARCH/lib/libx264.so.* $PREFIX_ARCH/lib/libx264.so
fi

echo "Android aac bulid success!"
