# -- Compile hidapi script
LIBHIDAPI_VER=0.9.0
LIBHIDAPI="hidapi-$LIBHIDAPI_VER"
export LIBHIDAPI_FOLDER="hidapi-$LIBHIDAPI"
TAR_LIBHIDAPI="$LIBHIDAPI.tar.gz"
REL_LIBHIDAPI="https://github.com/libusb/hidapi/archive/$TAR_LIBHIDAPI"

# -- Setup
. "$WORK_DIR/scripts/build_setup.sh"

cd "$UPSTREAM_DIR"

# -- Check and download the release
test -e "$TAR_LIBHIDAPI" || wget "$REL_LIBHIDAPI"

# -- Unpack the release
tar zxf "$TAR_LIBHIDAPI"

# -- Copy the upstream sources into the build directory
rsync -a "$LIBHIDAPI_FOLDER" "$BUILD_DIR" --exclude .git

cd "$BUILD_DIR/$LIBHIDAPI_FOLDER"

PREFIX="$BUILD_DIR/$LIBHIDAPI_FOLDER/release"
#export PKG_CONFIG_PATH="$BUILD_DIR/$LIBUSB/release/lib/pkgconfig"

#-- Build hidapi
if [ $ARCH != "darwin" ]; then
  ./bootstrap
  ./configure --prefix=$PREFIX --host=$HOST $CONFIG_FLAGS
   make -j$J
   make install
fi

echo ""
echo "----------> COMPILAR EJEMPLO!!!!"

#-- Build hidtest statically linked
cd hidtest
test -f "hidtest$EXE" && rm "hidtest$EXE"
if [ "$ARCH" == "darwin" ]; then
  # TODO
  $CC -o hidtest hidtest.cpp -lusb-1.0 -I../hidtest
else
  echo " $CC -o hidtest$EXE hidtest.cpp -static -L$PREFIX/lib -I$PREFIX/include/hidapi -lhidapi-libusb -L$BUILD_DIR/$LIBUSB/release/lib -lusb-1.0 -lpthread $EXTRA_LIB" 
  $CC -o "hidtest$EXE" hidtest.cpp -static -L"$PREFIX"/lib -I"$PREFIX"/include/hidapi -l$LIBHIDAPI_NAME -L"$BUILD_DIR/$LIBUSB"/release/lib -lusb-1.0 -lpthread $EXTRA_LIB
fi
cd ..

# # -- Test the generated executables

test_bin "hidtest/hidtest$EXE"

# # -- Copy the executable into the packages/bin dir
mkdir -p "$PACKAGE_DIR/$NAME/bin"
cp "hidtest/hidtest$EXE" "$PACKAGE_DIR/$NAME/bin/hidtest$EXE"
