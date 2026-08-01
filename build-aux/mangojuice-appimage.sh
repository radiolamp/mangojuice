#!/bin/sh

set -eu

ARCH=${ARCH:-$(uname -m)}
VERSION=${VERSION:-${GITHUB_SHA:-$(date +%Y%m%d)}}
APPDIR=${APPDIR:-"$PWD/AppDir"}
OUTPATH=${OUTPATH:-"$PWD/dist"}
OUTNAME=${OUTNAME:-"MangoJuice-${VERSION}-${ARCH}.AppImage"}

SHARUN=https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/quick-sharun.sh
DEBLOATED_PKGS=https://raw.githubusercontent.com/pkgforge-dev/Anylinux-AppImages/refs/heads/main/useful-tools/get-debloated-pkgs.sh

echo "Installing build dependencies..."
pacman -Syu --noconfirm \
    appstream \
    base-devel \
    cmocka \
    dbus \
    fmt \
    fontconfig \
    gcc-libs \
    gettext \
    git \
    glew \
    glfw \
    glib2 \
    glslang \
    gtk4 \
    hicolor-icon-theme \
    libadwaita \
    libgee \
    libglvnd \
    libsodium \
    libx11 \
    libxkbcommon \
    libxrandr \
    mesa-utils \
    meson \
    ninja \
    nlohmann-json \
    patchelf \
    pciutils \
    python \
    python-mako \
    python-matplotlib \
    python-numpy \
    strace \
    sudo \
    vala \
    vulkan-headers \
    vulkan-tools \
    wayland \
    wget \
    xorg-server-xvfb \
    zsync

if [ "$ARCH" = aarch64 ]; then
    echo "Building and installing vkBasalt from AUR..."
    useradd -m builder || true
    echo 'builder ALL=(ALL) NOPASSWD: /usr/bin/pacman' >> /etc/sudoers
    git clone https://aur.archlinux.org/vkbasalt.git /tmp/vkbasalt
    chown -R builder:builder /tmp/vkbasalt
    (cd /tmp/vkbasalt && su builder -c "makepkg -si --noconfirm -A")
else
    echo "Installing vkBasalt from Chaotic-AUR..."
    pacman-key --init
    pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
    pacman-key --lsign-key 3056513887B78AEB
    pacman --noconfirm -U https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst
    pacman --noconfirm -U https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst
    printf '%s\n' \
        '[chaotic-aur]' \
        'Include = /etc/pacman.d/chaotic-mirrorlist' >> /etc/pacman.conf
    pacman -Syu --noconfirm vkbasalt
fi

echo "Building and installing MangoJuice..."
meson setup build --prefix=/usr
ninja -C build
ninja -C build install

export ARCH APPDIR OUTPATH OUTNAME
export MAIN_BIN=mangojuice
export DESKTOP=/usr/share/applications/io.github.radiolamp.mangojuice.desktop
export ICON=/usr/share/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg
export DEPLOY_GTK=1
export DEPLOY_OPENGL=1
export DEPLOY_VULKAN=1

rm -rf "$APPDIR" "$OUTPATH"

echo "Downloading AppImage helpers..."
wget --retry-connrefused --tries=30 "$DEBLOATED_PKGS" -O ./get-debloated-pkgs
wget --retry-connrefused --tries=30 "$SHARUN" -O ./quick-sharun
chmod +x ./get-debloated-pkgs ./quick-sharun

echo "Installing debloated graphics packages..."
./get-debloated-pkgs --add-common --prefer-nano mangohud-mini

echo "Deploying MangoJuice dependencies..."
./quick-sharun 	/usr/bin/mangojuice \
                /usr/bin/vkcube \
                /usr/bin/lspci \
                /usr/bin/glxgears \
                /usr/bin/mangohud \
                /usr/lib/mangohud/* \
                /usr/lib/libvkbasalt.so*

# MangoJuice invokes previews as "mangohud mangohud vkcube". Replace the
# deployed MangoHud launcher with a wrapper that consumes the extra argument
# and starts the bundled vkcube with MangoHud enabled.
cat > "$APPDIR/bin/mangohud" <<'EOF'
#!/bin/sh
CURRENTDIR=$(dirname "$(readlink -f "$0")")
export GDK_BACKEND=x11
export MANGOHUD=1
shift
exec "$CURRENTDIR/vkcube" "$@"
EOF
chmod +x "$APPDIR/bin/mangohud"

mkdir -p "$APPDIR/share/vulkan/implicit_layer.d"
cp -v /usr/share/vulkan/implicit_layer.d/vkBasalt.json \
    "$APPDIR/share/vulkan/implicit_layer.d/"

echo "Creating MangoJuice AppImage..."
./quick-sharun --make-appimage

echo "Created AppImage: $OUTPATH/$OUTNAME"
