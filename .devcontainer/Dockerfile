FROM archlinux:base

RUN sed -i 's/^#ParallelDownloads = .*/ParallelDownloads = 10/' /etc/pacman.conf \
 && pacman -Syu --noconfirm --needed \
      base-devel git openssh \
      meson ninja vala \
      gtk4 libadwaita libgee \
      dbus xorg-xauth \
      mesa vulkan-icd-loader vulkan-headers \
      ttf-dejavu fish\
      vulkan-intel \
      mangohud vulkan-tools \
 && pacman -Scc --noconfirm

RUN <<'EOF' cat > /usr/local/bin/dev-shell
#!/bin/sh
export XDG_RUNTIME_DIR=/run/user/1000
export XAUTHORITY=/tmp/.docker.xauth
[ -s "$XAUTHORITY" ] || unset XAUTHORITY
exec dbus-run-session -- "$@"
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
