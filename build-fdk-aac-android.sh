#!/bin/sh
AAC_VERSION="2.0.0"
SOURCE="fdk-aac-$AAC_VERSION"
SHELL_PATH=$(pwd)
AAC_PATH=$SHELL_PATH/$SOURCE
PREFIX=$SHELL_PATH/aac_android
PREFIX_ARCH=$PREFIX/$ABI

AS_TMP=$AS
CFLAGS_TMP=$CFLAGS

#--disable-shared 不能禁用动态链接库ffmpeg需要动态库
AAC_CONFIGURE_FLAGS="--enable-static  --enable-shared  --enable-strip --enable-pic --target=android"
echo "TOOLCHAINS_PREFIX:$TOOLCHAINS_PREFIX"

export AS=$CC
export CFLAGS="$CFLAGS $EXTRA_CFLAGS"

rm -rf $PREFIX_ARCH
cd $AAC_PATH

$AAC_PATH/configure $AAC_CONFIGURE_FLAGS \
	--host=$TOOLCHAINS_PREFIX \
	$EXTRA_CONFIGURE_FLAGS \
	--prefix=$PREFIX_ARCH

make clean
make
make install

export AS=$AS_TMP
export CFLAGS=$CFLAGS_TMP

rm -rf "$PREFIX_ARCH/lib/pkgconfig"

echo "Android aac bulid success!"
