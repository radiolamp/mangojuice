#!/bin/sh

set -eu

ARCH=$(uname -m)
REPOSITORY=${GITHUB_REPOSITORY:-radiolamp/mangojuice}
export ARCH
export OUTPATH=./dist
export UPINFO="gh-releases-zsync|${REPOSITORY%/*}|${REPOSITORY#*/}|latest|*${ARCH}.AppImage.zsync"
export MAIN_BIN=mangojuice
export DESKTOP=/usr/share/applications/io.github.radiolamp.mangojuice.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

# Deploy dependencies
quick-sharun \
	/usr/bin/mangojuice \
	/usr/bin/vkcube     \
	/usr/bin/lspci      \
	/usr/bin/glxgears   \
	/usr/bin/mangohud   \
	/usr/lib/mangohud/* \
	/usr/lib/libvkbasalt.so*

mkdir -p ./AppDir/share/vulkan/implicit_layer.d
cp -v /usr/share/vulkan/implicit_layer.d/vkBasalt.json ./AppDir/share/vulkan/implicit_layer.d
# not needed, but leave it just in case the icd adds a full path to lib in the future
sed -i -e 's|/usr/.*/||g' ./AppDir/share/vulkan/implicit_layer.d/vkBasalt.json

# Turn AppDir into AppImage
quick-sharun --make-appimage

# Test the app for 12 seconds, if the test fails due to the app
# having issues running in the CI use --simple-test instead
quick-sharun --test ./dist/*.AppImage
