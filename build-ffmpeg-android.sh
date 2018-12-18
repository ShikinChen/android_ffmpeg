#!/bin/bash

#需要编译FFpmeg版本号
FF_VERSION="4.1"
SOURCE="ffmpeg-$FF_VERSION"
SHELL_PATH=$(pwd)
FF_PATH=$SHELL_PATH/$SOURCE
#输出路径
PREFIX=$SHELL_PATH/ffmpeg_android

X264=$SHELL_PATH/x264_android/$ABI
AAC=$SHELL_PATH/aac_android/$ABI

# echo "aac:$aac/${ARCH}/"

echo "CC:$CC"

FF_CONFIGURE_FLAGS="--disable-static --enable-shared --enable-pic --enable-postproc --disable-stripping"

#若使用android-ndk-r15c及以上NDK需要打此补丁(修改FFmepg与NDK代码冲突)
sh $SHELL_PATH/build-ffmpeg-patch.sh $FF_PATH

cd $FF_PATH
export TMPDIR=$FF_PATH/tmpdir
mkdir $TMPDIR

PREFIX_ARCH=$PREFIX/$ABI
rm -rf $PREFIX_ARCH

FF_EXTRA_CONFIGURE_FLAGS="${EXTRA_CONFIGURE_FLAGS} --extra-libs=-ldl --enable-libx264 --enable-encoder=libx264 --enable-libfdk-aac --enable-encoder=libfdk-aac --enable-nonfree"
FF_EXTRA_CFLAGS="${EXTRA_CFLAGS} -I$X264/include  -I$AAC/include"
FF_LDFLAGS="-L$X264/lib  -L$AAC/lib"

# FF_EXTRA_CONFIGURE_FLAGS="${EXTRA_CONFIGURE_FLAGS}  --enable-libfdk-aac --enable-encoder=libfdk-aac --enable-nonfree"
# FF_EXTRA_CFLAGS="${EXTRA_CFLAGS} -I$aac/${ABI}/include"
# FF_LDFLAGS="-L$aac/${ABI}/lib"

# echo "PREFIX_ARCH:${PREFIX_ARCH}"
# echo "FF_EXTRA_CONFIGURE_FLAGS:${FF_EXTRA_CONFIGURE_FLAGS}"
# echo "FF_EXTRA_CFLAGS:${FF_EXTRA_CFLAGS}"
# echo "FF_LDFLAGS:${FF_LDFLAGS}"

FF_CFLAGS="-U_FILE_OFFSET_BITS -O3 -pipe -Wall -ffast-math -fstrict-aliasing -Werror=strict-aliasing -Wno-psabi -Wa,--noexecstack -DANDROID"

echo "FF_CFLAGS:$FF_CFLAGS"

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
mv $PREFIX_ARCH/lib/*.so $PREFIX_ARCH/
rm -rf $PREFIX_ARCH/lib
rm -rf $PREFIX/include
mv $PREFIX_ARCH/include $PREFIX/

# cp $X264/lib/*.so $PREFIX_ARCH/
cp $AAC/lib/*.so $PREFIX_ARCH/

echo "Android FFmpeg bulid success!"
