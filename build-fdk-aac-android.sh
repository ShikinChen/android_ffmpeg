AAC_VERSION="0.1.6"
SOURCE="fdk-aac-$AAC_VERSION"
SHELL_PATH=$(pwd)
AAC_PATH=$SHELL_PATH/$SOURCE
PREFIX=$SHELL_PATH/aac_android
PREFIX_ARCH=$PREFIX/$ABI

AS_TMP=$AS

#--disable-shared 不能禁用动态链接库ffmpeg需要动态库
AAC_CONFIGURE_FLAGS="--enable-static --enable-strip --enable-pic --target=android"

export AS=$CC

cd $AAC_PATH

$AAC_PATH/configure $AAC_CONFIGURE_FLAGS \
	--host=$TOOLCHAINS_PREFIX \
	$EXTRA_CONFIGURE_FLAGS \
	--prefix=$PREFIX_ARCH

make clean
make
make install

export AS=$AS_TMP

rm -rf "$PREFIX_ARCH/lib/pkgconfig"
rm -rf $PREFIX_ARCH/lib/libfdk-aac.so
mv $PREFIX_ARCH/lib/libfdk-aac.so.* $PREFIX_ARCH/lib/libfdk-aac.so

echo "Android aac bulid success!"
