#!/bin/bash
##################################
# icesprog apio package builder   #
##################################

#FOR DEBUG, set everything=1 for release
# set -a # Comment this line if not already done. It's used to launch a bash later for debug purposes.
INSTALL_DEPS=1
COMPILE_LSUSB=1
COMPILE_HIDAPI=1
DOWNLOAD_ICESPROG=1
COMPILE_ICESPROG=1
CREATE_PACKAGE=1

# Library versions and names
LIBHIDAPI_VER=0.9.0
LIBHIDAPI="hidapi-$LIBHIDAPI_VER"
LIBHIDAPI2="hidapi-hidapi-$LIBHIDAPI_VER"
LIBUSB_VER=1.0.22
LIBUSB=libusb-$LIBUSB_VER

# Set english language for propper pattern matching
export LC_ALL=C

# Generate toolchain-icesprog-arch-ver.tar.gz
# sources: https://github.com/wuxx/icesugar/tree/master/tools/src

# -- icesprog apio package version
VERSION=1.0.0

# -- Target architectures
ARCH=$1
TARGET_ARCHS="linux_x86_64 linux_i686 linux_armv7l linux_aarch64 windows_x86 windows_amd64 darwin"

# -- Tools name
NAME=toolchain-icesprog

# -- Source fujprov filename (without arch)
SRC_NAME="icesprog-v"$SRC_MAYOR$SRC_MINOR"-"

# -- Source repository URL
SRC_URL="https://github.com/wuxx/icesugar"

# -- Tools path inside repository
SRC_PATH="tools/src"

# -- Trusted tag or commit
SRC_TAG="6424e0d8f8a48fe0bd77059bbc0fa9bf72767708"

# -- Store current dir
WORK_DIR="$(dirname "$(readlink -f "$0")")"

# -- Folder for creating the packages
PACKAGES_DIR="$WORK_DIR/_packages"

# -- Folder for sources
UPSTREAM_DIR="$WORK_DIR/_upstream"
ICESPROG_UPSTREAM_DIR="$UPSTREAM_DIR/icesprog"

# -- Folder for buiding
BUILDS_DIR="$WORK_DIR/_build"

# -- Release directory
RELEASE_DIR="$WORK_DIR/releases"

# -- Test script function
function test_bin {
  . $WORK_DIR/test/test_bin.sh $1
  if [ $? != "0" ]; then
    exit 1
  fi
}

# -- Print function
function print {
  echo ""
  echo "$1"
  echo ""
}

# -- Check ARCH
if [[ $# -gt 1 ]]; then
  echo ""
  echo "Error: too many arguments"
  exit 1
fi

if [[ $# -gt 1 ]]; then
  echo ""
  echo "Usage: bash build.sh TARGET"
  echo ""
  echo "Targets: $TARGET_ARCHS"
  exit 1
fi

if [[ $ARCH =~ [[:space:]] || ! $TARGET_ARCHS =~ (^|[[:space:]])$ARCH([[:space:]]|$) ]]; then
  echo ""
  echo ">>> WRONG ARCHITECTURE \"$ARCH\""
  exit 1
fi

# -- Directory for installating the target files
PACKAGE_DIR=$PACKAGES_DIR/pack_$ARCH

BUILD_DIR=$BUILDS_DIR/build_$ARCH


# -- Build actions start here --


echo ""
echo ">>> ARCHITECTURE \"$ARCH\""

# -- Source architecture: should be the same than target
# -- architecture, but the names in the icesprog and apio
# -- are different: Convert from icesprog to apio
if [ "$ARCH" == "windows_amd64" ]; then
  SRC_ARCH="win64"
  EXE=".exe"
  SRC_NAME="$SRC_NAME$SRC_ARCH$EXE"
fi

if [ "$ARCH" == "linux_x86_64" ]; then
  SRC_ARCH="linux-x64"
  EXE=""
  SRC_NAME="$SRC_NAME$SRC_ARCH$EXE"
fi

cd "$WORK_DIR"

# --------- Install dependencies ------------------------------------
if [ "$INSTALL_DEPS" == "1" ]; then

  print ">> Install dependencies"
  . $WORK_DIR/scripts/install_dependencies.sh

fi

# --------- Compile dependencies ------------------------------------

# -- Create the build directory
test -d "$BUILD_DIR" || mkdir -p "$BUILD_DIR"

# -- Create the packages directory
test -d "$PACKAGES_DIR" || mkdir -p "$PACKAGES_DIR"

# -- Create the package folders
test -d "$PACKAGE_DIR"/"$NAME" || mkdir -p "$PACKAGE_DIR"/"$NAME"

# --------- Compile lsusb ------------------------------------------
if [ "$COMPILE_LSUSB" == "1" ]; then

  print ">> Compile lsusb"
  . $WORK_DIR/scripts/compile_lsusb.sh
fi

# --------- Compile hidapi ------------------------------------------
if [ "$COMPILE_HIDAPI" == "1" ]; then

  print ">> Compile hidapi"
  . $WORK_DIR/scripts/compile_hidapi.sh
fi

# --------- Compile hidapi ------------------------------------------
if [ "$COMPILE_HIDAPI" == "1" ]; then

  print ">> Compile hidapi"
  . $WORK_DIR/scripts/compile_hidapi.sh
fi

# -- Create the upstream directory
test -d "$UPSTREAM_DIR" || mkdir "$UPSTREAM_DIR"

# --------- Compile icesprog ------------------------------------
if [ "$COMPILE_ICESPROG" == "1" ]; then

  print ">> Compile icesprog"
  . $WORK_DIR/scripts/compile_icesprog.sh
fi

# --------- Create the package -------------------------------------
if [ $CREATE_PACKAGE == "1" ]; then

  print ">> Create package"
  . $WORK_DIR/scripts/create_package.sh

fi


echo ""
