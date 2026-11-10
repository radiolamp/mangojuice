FROM archlinux:base

RUN pacman -Sy --noconfirm

RUN pacman -S --noconfirm --needed \
      base-devel git sudo openssh \
      meson ninja cmake make autoconf automake libtool pkgconf \
      vala gcc clang gettext patchelf \
      desktop-file-utils appstream-glib

RUN pacman -S --noconfirm --needed \
      gtk4 libadwaita libgee glib2 pango cairo gdk-pixbuf2 \
      at-spi2-core fontconfig \
      ttf-dejavu ttf-liberation noto-fonts noto-fonts-emoji

RUN pacman -S --noconfirm --needed \
      libx11 libxext libxrender libxfixes libxi libxrandr libxcursor libxinerama \
      libxkbcommon xorg-xauth \
      dbus dbus-broker

RUN pacman -S --noconfirm --needed \
      mesa mesa-demos libglvnd \
      wayland wayland-protocols \
      vulkan-icd-loader vulkan-headers vulkan-intel vulkan-radeon vulkan-tools \
      glslang shaderc spirv-headers \
      pciutils usbutils mangohud

RUN pacman -Scc --noconfirm

RUN <<'EOF' cat > /usr/local/bin/dev-shell
#!/bin/sh
export XDG_RUNTIME_DIR=/run/user/1000
export XAUTHORITY=/tmp/.docker.xauth
[ -s "$XAUTHORITY" ] || unset XAUTHORITY
[ -S "$XDG_RUNTIME_DIR/gcr/ssh" ] && export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
if [ -S "$XDG_RUNTIME_DIR/bus" ]; then
    exec "$@"
else
    exec dbus-run-session -- "$@"
fi
EOF

RUN <<'EOF' cat > /usr/local/bin/dev-xauth
#!/bin/sh
: > /tmp/.docker.xauth
chmod 600 /tmp/.docker.xauth
for f in /run/user/1000/.mutter-Xwaylandauth.* /run/user/1000/gdm-Xauthority; do
    [ -f "$f" ] || continue
    XAUTHORITY="$f" xauth nlist "${DISPLAY:-:0}" 2>/dev/null \
        | sed 's/^..../ffff/' \
        | xauth -f /tmp/.docker.xauth nmerge - 2>/dev/null \
        && break
done
EOF

RUN chmod +x /usr/local/bin/dev-shell /usr/local/bin/dev-xauth

WORKDIR /workspaces/mangojuice