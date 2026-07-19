#!/bin/bash

set -eu

export ARCH="$(uname -m)"
export APPIMAGE_EXTRACT_AND_RUN=1
export VERSION="${GITHUB_SHA:-$(date +%Y%m%d)}"
UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY:-radiolamp/mangojuice}|latest|*$ARCH.AppImage.zsync"

LIB4BN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"
URUNTIME="https://github.com/VHSgunzo/uruntime/releases/latest/download/uruntime-appimage-dwarfs-$ARCH"
URUNTIME_LITE="https://github.com/VHSgunzo/uruntime/releases/latest/download/uruntime-appimage-dwarfs-lite-$ARCH"

# add debloated packages
if [ "$(uname -m)" = 'x86_64' ]; then
    PKG_TYPE='x86_64.pkg.tar.zst'
else
    PKG_TYPE='aarch64.pkg.tar.xz'
fi

LLVM_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/llvm-libs-nano-$PKG_TYPE"
LIBXML_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/libxml2-iculess-$PKG_TYPE"
MESA_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/mesa-mini-$PKG_TYPE"
VK_RADEON_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-radeon-mini-$PKG_TYPE"
VK_INTEL_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-intel-mini-$PKG_TYPE"
VK_NOUVEAU_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-nouveau-mini-$PKG_TYPE"
VK_PANFROST_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-panfrost-mini-$PKG_TYPE"
VK_FREEDRENO_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-freedreno-mini-$PKG_TYPE"
VK_BROADCOM_URL="https://github.com/pkgforge-dev/llvm-libs-debloated/releases/download/continuous/vulkan-broadcom-mini-$PKG_TYPE"

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
wget --retry-connrefused --tries=30 "$LLVM_URL"        -O  ./llvm-libs.pkg.tar.zst
wget --retry-connrefused --tries=30 "$LIBXML_URL"      -O  ./libxml2.pkg.tar.zst
wget --retry-connrefused --tries=30 "$MESA_URL"        -O  ./mesa.pkg.tar.zst
wget --retry-connrefused --tries=30 "$VK_RADEON_URL"   -O  ./vulkan-radeon.pkg.tar.zst
wget --retry-connrefused --tries=30 "$VK_NOUVEAU_URL"  -O  ./vulkan-nouveau.pkg.tar.zst

if [ "$(uname -m)" = 'x86_64' ]; then
    wget --retry-connrefused --tries=30 "$VK_INTEL_URL"     -O ./vulkan-intel.pkg.tar.zst
else
    wget --retry-connrefused --tries=30 "$VK_PANFROST_URL"  -O ./vulkan-panfrost.pkg.tar.zst
    wget --retry-connrefused --tries=30 "$VK_FREEDRENO_URL" -O ./vulkan-freedreno.pkg.tar.zst
    wget --retry-connrefused --tries=30 "$VK_BROADCOM_URL"  -O ./vulkan-broadcom.pkg.tar.zst
fi

pacman -U --noconfirm ./*.pkg.tar.zst
rm -f ./*.pkg.tar.zst

echo "Making AppImage..."
echo "---------------------------------------------------------------"
mkdir -p ./AppDir
cd ./AppDir || exit

if [ -f "/usr/share/applications/io.github.radiolamp.mangojuice.desktop" ]; then
    cp "/usr/share/applications/io.github.radiolamp.mangojuice.desktop" ./
    sed -i 's|^Exec=.*|Exec=mangojuice|' ./io.github.radiolamp.mangojuice.desktop
else
    echo "Error: .desktop file isn't exist"
    exit 1
fi

if [ -f "/usr/share/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg" ]; then
    cp "/usr/share/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg" ./
    cp "./io.github.radiolamp.mangojuice.svg" ./.DirIcon
else
    echo "Warning: icon file isn't found"
fi

for icon in /usr/share/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice*.svg; do
    mkdir -p ./share/icons/hicolor/scalable/apps/
    cp "$icon" ./share/icons/hicolor/scalable/apps/
done

mkdir -p ./share/locale
for mo_file in /usr/share/locale/*/LC_MESSAGES/mangojuice.mo; do
    lang_dir=$(dirname "$(dirname "$mo_file")")
    lang=$(basename "$lang_dir")
    if [[ "$lang" =~ ^[a-z]{2}$ ]]; then
        lang="${lang}_${lang^^}"
    fi
    mkdir -p "./share/locale/$lang/LC_MESSAGES"
    cp "$mo_file" "./share/locale/$lang/LC_MESSAGES/mangojuice.mo"
done

echo "Downloading lib4bin..."
wget --retry-connrefused --tries=30 "$LIB4BN" -O ./lib4bin || {
    echo "Error downloading lib4bin"
    exit 1
}
chmod +x ./lib4bin

echo "Copying files of mangojuice..."
xvfb-run -a -- ./lib4bin -p -v -e -s -k \
    /usr/bin/mangojuice \
    /usr/bin/vkcube \
    /usr/lib/mangohud/* \
    /usr/bin/lspci \
    /usr/lib/libintl.so* \
    /usr/lib/gdk-pixbuf-*/*/*/* || {
    echo "Error with copying files"
    exit 1
}

mkdir -p ./share/vulkan
if [ -d "/usr/share/vulkan/implicit_layer.d" ]; then
    cp -rv "/usr/share/vulkan/implicit_layer.d" "./share/vulkan/"
    sed -i 's|/usr/lib/mangohud/||' ./share/vulkan/implicit_layer.d/*
else
    echo "Warning: Vulkan layers isn't found"
fi

# mangojuice is also going to run mangohud vkcube so we need to wrap this
echo '#!/bin/sh
CURRENTDIR="$(dirname "$(readlink -f "$0")")"
export GDK_BACKEND=x11
export MANGOHUD=1
shift
"$CURRENTDIR"/vkcube "$@"' > ./bin/mangohud
chmod +x ./bin/mangohud

# copy anything that remains in ./usr/share to ./share
cp -rv ./usr/share/* ./share || true
rm -rf ./usr/share

# prepare sharun
ln ./sharun ./AppRun
./sharun -g

echo 'MANGOJUICE=1' > ./.env
echo 'TEXTDOMAINDIR="${SHARUN_DIR}/share/locale' >> ./.env
echo 'TEXTDOMAIN="mangojuice' >> ./.env
echo 'libMangoHud_shim.so' > ./.preload

# Additional checking file structure
echo "=== Checking file structure ==="
echo "Files in AppDir:"
ls -la | grep -E "(DirIcon|desktop|svg)"
echo "Desktop file:"
cat *.desktop 2>/dev/null | grep -E "(Icon|Name)"

cd .. || exit

# Check that the symlink has been created
echo "Checking the .DirIcon symlink in the root:"
ls -la .DirIcon 2>/dev/null || echo "Warning: .DirIcon symlink not created"

echo "Downloading uruntime..."
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime || {
    echo "Error downloading uruntime"
    exit 1
}
wget --retry-connrefused --tries=30 "$URUNTIME_LITE" -O ./uruntime-lite || {
    echo "Error downloading uruntime-lite"
    exit 1
}
chmod +x ./uruntime*

echo "Adding update info..."
./uruntime-lite --appimage-addupdinfo "$UPINFO" || {
    echo "Error with adding update info"
    exit 1
}

echo "Creating AppImage..."
./uruntime --appimage-mkdwarfs -f \
    --set-owner 0 --set-group 0 \
    --no-history --no-create-timestamp \
    --compression zstd:level=22 -S26 -B8 \
    --header uruntime-lite \
    -i ./AppDir -o "MangoJuice-${VERSION}-${ARCH}.AppImage" || {
    echo "AppImage isn't created"
    exit 1
}

echo "Great! Created AppImage: MangoJuice-${VERSION}-${ARCH}.AppImage"
