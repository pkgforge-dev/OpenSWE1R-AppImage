#!/bin/sh

set -eu

ARCH=$(uname -m)

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
    enet     \
    libdecor \
    openal   \
    sdl2     \
    unicorn

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano

# Comment this out if you need an AUR package
#make-aur-package PACKAGENAME

# If the application needs to be manually built that has to be done down here
echo "Making nightly build of OpenSWE1R..."
echo "---------------------------------------------------------------"
REPO="https://github.com/OpenSWE1R/openswe1r"
VERSION="$(git ls-remote "$REPO" HEAD | cut -c 1-9 | head -1)"
git clone "$REPO" ./openswe1r
echo "$VERSION" > ~/version

mkdir -p ./AppDir/bin
cd ./openswe1r
mkdir -p build && cd build
cmake .. \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_C_FLAGS="-Wno-incompatible-pointer-types" \
    -DCMAKE_POLICY_VERSION_MINIMUM=3.5
make -j$(nproc)
mv -v openswe1r ../../AppDir/bin
