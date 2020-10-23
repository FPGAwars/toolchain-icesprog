# -- Compile hidapi script

TAR_LIBHIDAPI="$LIBHIDAPI.tar.gz"
REL_LIBHIDAPI="https://github.com/libusb/hidapi/archive/$TAR_LIBHIDAPI"

# -- Setup
. "$WORK_DIR/scripts/build_setup.sh"

cd "$UPSTREAM_DIR"

# -- Check and download the release
test -e "$TAR_LIBHIDAPI "|| wget "$REL_LIBHIDAPI"

# -- Unpack the release
tar zxf "$TAR_LIBHIDAPI"

# -- Copy the upstream sources into the build directory
rsync -a "$LIBHIDAPI2" "$BUILD_DIR" --exclude .git

cd "$BUILD_DIR/$LIBHIDAPI2"

PREFIX="$BUILD_DIR/$LIBHIDAPI2/release"
export PKG_CONFIG_PATH="$BUILD_DIR/$LIBUSB/release/lib/pkgconfig"

#-- Build hidapi
if [ $ARCH != "darwin" ]; then
  ./bootstrap
  ./configure --prefix=$PREFIX --host=$HOST --enable-udev=no $CONFIG_FLAGS
#  make -j$J
#  make install
fi

if [ "${ARCH:0:5}" == "linux" ]; then
  # cd libusb
  make -j"$J"
  make install
  #cd ..
elif [ "${ARCH:0:7}" == "windows" ]; then
  #cd windows
  make -j"$J"
  make install
  #cd ..
else
  # TODO
  print "Architecture not currently supported by build script $0"
  exit -1
fi

# hidtest/.libs/hidtest-libusb is dynamically linked so we compile it again

#-- Build hidtest statically linked
cd hidtest
test -f "hidtest$EXE" && rm "hidtest$EXE"
if [ "$ARCH" == "darwin" ]; then
  # TODO
  $CC -o hidtest hidtest.cpp -lusb-1.0 -I../hidtest
elif [ "${ARCH:0:7}" == "windows" ]; then
  $CC -o "hidtest$EXE" hidtest.cpp -static -L"$PREFIX"/lib -I"$PREFIX"/include/hidapi -lhidapi -L"$BUILD_DIR/$LIBUSB"/release/lib -lusb-1.0 -lpthread -lsetupapi
else
  $CC -o "hidtest$EXE" hidtest.cpp -static -L"$PREFIX"/lib -I"$PREFIX"/include/hidapi -lhidapi-libusb -L"$BUILD_DIR/$LIBUSB"/release/lib -lusb-1.0 -lpthread
fi
cd ..

# # -- Test the generated executables

test_bin "hidtest/hidtest$EXE"

# # -- Copy the executable into the packages/bin dir
mkdir -p "$PACKAGE_DIR/$NAME/bin"
cp "hidtest/hidtest$EXE" "$PACKAGE_DIR/$NAME/bin/hidtest$EXE"
