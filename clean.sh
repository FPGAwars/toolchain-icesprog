#!/bin/bash

# -- Target architectures
ARCH=$1
TARGET_ARCHS="linux_x86_64 windows_amd64 darwin"

# -- Store current dir
WORK_DIR="$(dirname "$(readlink -f "$0")")"

# -- Folder for storing the downloaded packages
PACKAGES_DIR="$WORK_DIR/_packages"

# -- Folder for buiding
BUILDS_DIR="$WORK_DIR/_build"

# -- Folder for storing upstream resources
#UPSTREAM_DIR="$WORK_DIR/_upstream"


# -- Check ARCH
if [[ $# -gt 1 ]]; then
  echo ""
  echo "Error: too many arguments"
  exit 1
fi

if [[ $# -gt 1 ]]; then
  echo ""
  echo "Usage: bash clean.sh TARGET"
  echo ""
  echo "Targets: $TARGET_ARCHS"
  exit 1
fi

if [[ $ARCH =~ [[:space:]] || ! $TARGET_ARCHS =~ (^|[[:space:]])$ARCH([[:space:]]|$) ]]; then
  echo ""
  echo ">>> WRONG ARCHITECTURE \"$ARCH\""
  exit 1
fi

echo ""
echo ">>> ARCHITECTURE \"$ARCH\""

printf "Are you sure? [y/N]:" 
read -r RESP
case "$RESP" in
    [yY][eE][sS]|[yY])

      # -- Directory for building
      PACKAGE_DIR="$PACKAGES_DIR/build_$ARCH"

      # -- Directory for installation the target files
      BUILD_DIR="$BUILDS_DIR/pack_$ARCH"

      # -- Remove the package dir
      rm -r -f "$PACKAGE_DIR"

      # -- Remove the build dir
      rm -r -f "$BUILD_DIR"

      # -- Remove the upstream dir
      #rm -r -f "$UPSTREAM_DIR"

      # -- Remove the package from the releases folder
      rm -f releases/toolchain-*-"$ARCH"*

      echo ""
      echo ">> CLEAN"
      ;;
    *)
      echo ""
      echo ">> ABORT"
      ;;
esac
