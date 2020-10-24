# -- Compile hidapi script

# -- Setup
. "$WORK_DIR/scripts/build_setup.sh"

# --------- Download icesugar ------------------------------------
if [ "$DOWNLOAD_ICESPROG" == "1" ]; then
  echo "Download from: ""$SRC_URL"

  # TODO ask maybe?
  rm -rf "$ICESPROG_UPSTREAM_DIR"

  git clone -- "$SRC_URL" "$ICESPROG_UPSTREAM_DIR"

  cd "$ICESPROG_UPSTREAM_DIR"

  git checkout "$SRC_TAG"

  cd "$WORK_DIR"

fi

# -- Copy the upstream sources into the build directory
rsync -vaz "$ICESPROG_UPSTREAM_DIR/tools/src/" "$BUILD_DIR/icesprog" --exclude .git

cd "$BUILD_DIR/icesprog"

#-- Build icesprog statically linked
test -f "hidtest$EXE" && rm "hidtest$EXE"
if [ "$ARCH" == "darwin" ]; then
  # TODO
  $CC -o icesprog icesprog.c -lusb-1.0
elif [ "${ARCH:0:7}" == "windows" ]; then

  # windows libc converts line ending by default. This is a workarround.
  echo -e "#if (defined _WIN32 || defined WIN32) && ! defined CYGWIN
  #include <fcntl.h>
  int _fmode = _O_BINARY;
  #endif" > binmode.c

  $CC -o "icesprog$EXE" icesprog.c binmode.c -static -L"$BUILD_DIR/$LIBHIDAPI2"/release/lib -I"$BUILD_DIR/$LIBHIDAPI2"/release/include/hidapi -lhidapi -L"$BUILD_DIR/$LIBUSB"/release/lib -I"$BUILD_DIR/$LIBUSB"/release/include/libusb-1.0 -lusb-1.0 -lpthread -lsetupapi

else
  $CC -o "icesprog$EXE" icesprog.c -static -L"$BUILD_DIR/$LIBHIDAPI2"/release/lib -I"$BUILD_DIR/$LIBHIDAPI2"/release/include/hidapi -lhidapi-libusb -L"$BUILD_DIR/$LIBUSB"/release/lib -I"$BUILD_DIR/$LIBUSB"/release/include/libusb-1.0 -lusb-1.0 -lpthread
fi
cd ..

# # -- Test the generated executables

test_bin "icesprog/icesprog$EXE"

# # -- Copy the executable into the packages/bin dir
mkdir -p "$PACKAGE_DIR/$NAME/bin"
cp "icesprog/icesprog$EXE" "$PACKAGE_DIR/$NAME/bin/icesprog$EXE"
