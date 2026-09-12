#!/bin/sh

set -eu

echo "Installing package dependencies..."
echo "---------------------------------------------------------------"
pacman -Syu --noconfirm \
	libadwaita \
	libgee \
	mesa-utils \
	meson \
	pciutils \
	vala \
	vulkan-tools

echo "Installing debloated packages..."
echo "---------------------------------------------------------------"
get-debloated-pkgs --add-common --prefer-nano mangohud-mini

echo "Building and installing vkBasalt from the AUR..."
echo "---------------------------------------------------------------"
( cd /tmp && make-aur-package vkbasalt )

echo "Building and installing MangoJuice..."
echo "---------------------------------------------------------------"
meson setup build-appimage --prefix=/usr
meson compile -C build-appimage
meson install -C build-appimage

meson introspect --projectinfo build-appimage | python3 -c \
	'import json, sys; print(json.load(sys.stdin)["version"])' > ~/version


