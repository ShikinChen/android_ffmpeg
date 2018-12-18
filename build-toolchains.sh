#!/bin/sh

NDK_ROOT=~/Software/Development/android-ndk-r17c

ANDROID_API_VERSION=18
NDK_TOOLCHAIN_ABI_VERSION=4.9

ABI=$1

# echo "ABI"$ABI

TOOLCHAINS=$(pwd)/"toolchains"
TOOLCHAINS_PREFIX="arm-linux-androideabi"
TOOLCHAINS_PATH=${TOOLCHAINS}/bin
SYSROOT=${TOOLCHAINS}/sysroot
LDFLAGS=""
EXTRA_CONFIGURE_FLAGS=""
EXTRA_CFLAGS=""
CFLAGS="--sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${TOOLCHAINS}/include -isysroot ${SYSROOT}"
# CFLAGS="${CFLAGS} --sysroot=${SYSROOT} -I${SYSROOT}/usr/include -I${TOOLCHAINS}/include"
CPPFLAGS="${CFLAGS}"
CXXFLAGS="${CFLAGS}"
LDFLAGS="${LDFLAGS} -L${SYSROOT}/usr/lib -L${TOOLCHAINS}/lib"

CWD=$(pwd)

ARCH_PREFIX="armeabi"

function make_standalone_toolchain() {
	echo "make standalone toolchain --arch=$1 --api=$2 --install-dir=$3"
	rm -rf ${TOOLCHAINS}

	$NDK_ROOT/build/tools/make_standalone_toolchain.py \
		--arch=$1 \
		--api=$2 \
		--install-dir=$3 \
		--stl=stlport \
		-v
	# --stl=gnustl \'gnustl', 'libc++', 'stlport'

}

function export_vars() {
	CROSS_PREFIX=${TOOLCHAINS_PATH}/${TOOLCHAINS_PREFIX}-
	echo "

    export TOOLCHAINS=${TOOLCHAINS}
    export TOOLCHAINS_PREFIX=${TOOLCHAINS_PREFIX}
    export TOOLCHAINS_PATH=${TOOLCHAINS_PATH}
    export SYSROOT=${SYSROOT}
    export CROSS_PREFIX=${CROSS_PREFIX}

    export CPP=${CROSS_PREFIX}cpp
    export AR=${CROSS_PREFIX}ar
    export AS=${CROSS_PREFIX}as
    export NM=${CROSS_PREFIX}nm
    export CC=${CROSS_PREFIX}gcc
    export CXX=${CROSS_PREFIX}g++
    export LD=${CROSS_PREFIX}ld
    export RANLIB=${CROSS_PREFIX}ranlib
    export STRIP=${CROSS_PREFIX}strip
    export OBJDUMP=${CROSS_PREFIX}objdump
    export OBJCOPY=${CROSS_PREFIX}objcopy
    export ADDR2LINE=${CROSS_PREFIX}addr2line
    export READELF=${CROSS_PREFIX}readelf
    export SIZE=${CROSS_PREFIX}size
    export STRINGS=${CROSS_PREFIX}strings
    export ELFEDIT=${CROSS_PREFIX}elfedit
    export GCOV=${CROSS_PREFIX}gcov
    export GDB=${CROSS_PREFIX}gdb
    export GPROF=${CROSS_PREFIX}gprof
    
    # Don't mix up .pc files from your host and build target
    export PKG_CONFIG_PATH=${TOOLCHAINS}/lib/pkgconfig
    
    export CFLAGS=\" ${CFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION\"
	export CXXFLAGS=\" ${CXXFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION\"
    export CPPFLAGS=\" ${CPPFLAGS}\"
    export LDFLAGS=\" ${LDFLAGS}\"

    export EXTRA_CONFIGURE_FLAGS=\" ${EXTRA_CONFIGURE_FLAGS}\"
    export EXTRA_CFLAGS=\" ${EXTRA_CFLAGS}\"

    export ABI=${ABI}

    export ARCH=${ARCH}

    export ANDROID_API_VERSION=${ANDROID_API_VERSION}
    " >toolchain.cfg
}

function x86_64_extra_flags() {
	EXTRA_CONFIGURE_FLAGS="--disable-asm"
	EXTRA_CFLAGS="-Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -fomit-frame-pointer -march=k8"
}

echo "building $ABI..."
ARCH=$ABI
if [ $ABI = "armeabi" ]; then
	# CFLAGS="${CFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION"
	make_standalone_toolchain arm $ANDROID_API_VERSION ${TOOLCHAINS}
	TOOLCHAINS_PREFIX=arm-linux-androideabi
	ARCH_PREFIX=$ABI
	EXTRA_CONFIGURE_FLAGS="--disable-asm"
	EXTRA_CFLAGS="-march=armv5te"
	ARCH="arm"
	export_vars
elif [ $ABI = "armeabi-v7a" ]; then
	# CFLAGS="${CFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION"
	make_standalone_toolchain arm $ANDROID_API_VERSION ${TOOLCHAINS}
	TOOLCHAINS_PREFIX=arm-linux-androideabi
	ARCH_PREFIX=$ABI
	EXTRA_CONFIGURE_FLAGS="--disable-asm"
	# EXTRA_CFLAGS="-march=armv7-a -mfloat-abi=softfp -mfpu=neon"
	EXTRA_CFLAGS="-fpic -ffunction-sections -funwind-tables -fstack-protector -march=armv7-a -mfloat-abi=softfp -mfpu=vfpv3-d16 -fomit-frame-pointer -fstrict-aliasing -funswitch-loops -finline-limit=300"
	ARCH="arm"
	export_vars
elif [ $ABI = "arm64-v8a" ]; then
	ANDROID_API_VERSION=21
	# CFLAGS="${CFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION"
	make_standalone_toolchain arm64 $ANDROID_API_VERSION ${TOOLCHAINS}
	TOOLCHAINS_PREFIX=aarch64-linux-android
	ARCH_PREFIX=$ABI
	EXTRA_CONFIGURE_FLAGS="--enable-asm"
	EXTRA_CFLAGS="-march=armv8-a"
	ARCH="aarch64"
	export_vars
elif [ $ABI = "x86" ]; then
	# CFLAGS="${CFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION"
	make_standalone_toolchain x86 $ANDROID_API_VERSION ${TOOLCHAINS}
	TOOLCHAINS_PREFIX=i686-linux-android
	ARCH_PREFIX=$ABI
	# x86_64_extra_flags
	EXTRA_CONFIGURE_FLAGS="--disable-asm"
	EXTRA_CFLAGS="-march=i686 -mtune=intel -mssse3 -mfpmath=sse -m32"
	export_vars
elif [ $ABI = "x86_64" ]; then
	ANDROID_API_VERSION=21
	# CFLAGS="${CFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION"
	make_standalone_toolchain x86_64 $ANDROID_API_VERSION ${TOOLCHAINS}
	TOOLCHAINS_PREFIX=x86_64-linux-android
	ARCH_PREFIX=$ABI
	# x86_64_extra_flags
	EXTRA_CONFIGURE_FLAGS="--disable-asm"
	EXTRA_CFLAGS="-march=x86-64 -msse4.2 -mpopcnt -m64 -mtune=intel"
	export_vars
elif [ $ABI = "mips" ]; then
	ANDROID_API_VERSION=21
	# CFLAGS="${CFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION"
	make_standalone_toolchain mips $ANDROID_API_VERSION ${TOOLCHAINS}
	TOOLCHAINS_PREFIX=mipsel-linux-android
	ARCH_PREFIX=$ABI
	export_vars
elif [ $ABI = "mips64" ]; then
	ANDROID_API_VERSION=21
	# CFLAGS="${CFLAGS} -D__ANDROID_API__=$ANDROID_API_VERSION"
	make_standalone_toolchain mips64 $ANDROID_API_VERSION ${TOOLCHAINS}
	TOOLCHAINS_PREFIX=mips64el-linux-android
	ARCH_PREFIX=$ABI
	export_vars
else
	echo $ABI
fi

cd $CWD
