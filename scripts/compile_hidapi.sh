#!/bin/bash

# -- Compile hidapi script
LIBHIDAPI_VER=0.9.0
LIBHIDAPI="hidapi-$LIBHIDAPI_VER"

# -- This vars are inherited from compile_lsusb.sh but you will need them here if you disable it's COMPILE_LSUSB flag
# LIBUSB_VER=1.0.22
# LIBUSB=libusb-$LIBUSB_VER

LIBHIDAPI_FOLDER="hidapi-$LIBHIDAPI"
TAR_LIBHIDAPI="$LIBHIDAPI.tar.gz"
REL_LIBHIDAPI="https://github.com/libusb/hidapi/archive/$TAR_LIBHIDAPI"

# -- Setup
# shellcheck source=scripts/build_setup.sh
. "$WORK_DIR"/scripts/build_setup.sh

cd "$UPSTREAM_DIR" || exit

# -- Check and download the release
test -e "$TAR_LIBHIDAPI" || wget "$REL_LIBHIDAPI"

# -- Unpack the release
tar zxf "$TAR_LIBHIDAPI"

# -- Copy the upstream sources into the build directory
rsync -a "$LIBHIDAPI_FOLDER" "$BUILD_DIR" --exclude .git

cd "$BUILD_DIR/$LIBHIDAPI_FOLDER" || exit

PREFIX="$BUILD_DIR/$LIBHIDAPI_FOLDER/release"
#export PKG_CONFIG_PATH="$BUILD_DIR/$LIBUSB/release/lib/pkgconfig"

#-- Build hidapi
if [ "$ARCH" != "darwin" ]; then
  ./bootstrap
  ./configure --prefix="$PREFIX" --host=$HOST "$CONFIG_FLAGS"
   make -j$J
   make install
fi

#------- Build hidtest
if [ "$ARCH" == "darwin" ]; then
  # -- Manual compilation
  cd mac
  make -f Makefile-manual
  cp hidtest ../hidtest
else
  #-- Build hidtest statically linked
cd hidtest || exit
test -f "hidtest$EXE" && rm "hidtest$EXE"
  $CC -o "hidtest$EXE" hidtest.cpp -static -L"$PREFIX"/lib -I"$PREFIX"/include/hidapi -l$LIBHIDAPI_NAME -L"$BUILD_DIR/$LIBUSB"/release/lib -lusb-1.0 -lpthread $EXTRA_LIB
fi
cd ..

# # -- Test the generated executables

test_bin "hidtest/hidtest$EXE"

# # -- Copy the executable into the packages/bin dir
mkdir -p "$PACKAGE_DIR/$NAME/bin"
cp "hidtest/hidtest$EXE" "$PACKAGE_DIR/$NAME/bin/hidtest$EXE"
