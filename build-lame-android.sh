#!/bin/sh
LAME_VERSION="3.100"
SOURCE="lame-$LAME_VERSION"
SHELL_PATH=$(pwd)
LAME_PATH=$SHELL_PATH/$SOURCE
PREFIX=$SHELL_PATH/lame_android
PREFIX_ARCH=$PREFIX/$ABI

AS_TMP=$AS
CFLAGS_TMP=$CFLAGS

LAME_CONFIGURE_FLAGS="--enable-static  --disable-shared  --disable-frontend"

rm -rf $PREFIX_ARCH
cd $LAME_PATH

$LAME_PATH/configure $LAME_CONFIGURE_FLAGS \
	--host=$TOOLCHAINS_PREFIX \
	$EXTRA_CONFIGURE_FLAGS \
	--prefix=$PREFIX_ARCH

make clean
make
make install

echo "Android lame bulid success!"
