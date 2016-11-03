#! /bin/bash
# This script builds static i2pd binary (for the same platform as host)

WDIR=${WDIR:=$PWD}

# Prepare build directory
BUILD_DIR=$WDIR/build
[ ! -d $BUILD_DIR/src ] && mkdir -p $BUILD_DIR/src

# Download all required sources
cd $BUILD_DIR/src
wget https://sourceforge.net/projects/boost/files/boost/1.61.0/boost_1_61_0.tar.gz
wget https://www.openssl.org/source/openssl-1.0.2j.tar.gz
wget http://zlib.net/zlib-1.2.8.tar.gz
git clone https://github.com/PurpleI2P/i2pd.git

# Build zlib
cd $BUILD_DIR/src
tar -xzf zlib-1.2.8.tar.gz
cd zlib-1.2.8
./configure --prefix=$BUILD_DIR --static
make && make install

# Build openssl
cd $BUILD_DIR/src
tar -xzf openssl-1.0.2j.tar.gz
cd openssl-1.0.2j
./config --prefix=$BUILD_DIR no-shared
make && make install

# Build boost
cd $BUILD_DIR/src
tar -xzf boost_1_61_0.tar.gz
cd boost_1_61_0
./bootstrap.sh --prefix=$BUILD_DIR --without-icu --without-libraries='python,mpi,log,wave,graph,math,context,coroutine,coroutine2,iostreams'
# Next command will take some time, go get a cup of tea, pet your cat, etc
./b2 install

# Build i2pd
cd $BUILD_DIR/src/i2pd
make LIBDIR="$BUILD_DIR/lib" USE_AESNI=no USE_STATIC=yes INCFLAGS="-I$BUILD_DIR/include"
strip i2pd

[ -f $BUILD_DIR/src/i2pd/i2pd ] && echo "[!] Binary is ready: $BUILD_DIR/src/i2pd/i2pd"
