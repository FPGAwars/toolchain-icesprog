# -- Compile hidapi script

SRC_ICESPROG="https://github.com/wuxx/icesugar"
ICESUGAR="icesugar"

# -- Trusted tag or commit
SRC_TAG="6424e0d8f8a48fe0bd77059bbc0fa9bf72767708"

# -- Setup
. "$WORK_DIR/scripts/build_setup.sh"

cd "$UPSTREAM_DIR" || exit

#-- Clone the icesugar repo
test -e icesugar || git clone $SRC_ICESPROG

#-- Enter into the icesugar folder
cd $ICESUGAR || exit

#-- Checkout the trusted tag
git checkout "$SRC_TAG"

cd ..

 #-- Copy the upstream sources into the build directory
 rsync -a $ICESUGAR/tools/src/* "$BUILD_DIR/icesprog" --exclude .git

#-- Enter into the sources folder
cd "$BUILD_DIR/icesprog" || exit

PREFIX_LIBHIDAPI="$BUILD_DIR/$LIBHIDAPI_FOLDER/release"
PREFIX_LIBUSB="$BUILD_DIR/$LIBUSB"/release

if [ "$ARCH" == "darwin" ]; then
  # TODO
  $CC -o hidtest hidtest.cpp -lusb-1.0 -I../hidtest
else
echo "PREFIX_LIBUSB: $PREFIX_LIBUSB"
  $CC -o "icesprog$EXE" icesprog.c -static -L"$PREFIX_LIBHIDAPI"/lib -I"$PREFIX_LIBHIDAPI"/include/hidapi -lhidapi-libusb -L"$PREFIX_LIBUSB"/lib -lusb-1.0 -lpthread -I"$PREFIX_LIBUSB"/include/libusb-1.0
fi

cd ..

# # -- Test the generated executables

test_bin "icesprog/icesprog$EXE"

# # -- Copy the executable into the packages/bin dir
mkdir -p "$PACKAGE_DIR/$NAME/bin"
cp "icesprog/icesprog$EXE" "$PACKAGE_DIR/$NAME/bin/icesprog$EXE"
