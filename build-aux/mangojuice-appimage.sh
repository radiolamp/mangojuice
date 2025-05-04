#!/bin/bash

set -eu

export ARCH="$(uname -m)"
export APPIMAGE_EXTRACT_AND_RUN=1
export VERSION="${GITHUB_SHA:-$(date +%Y%m%d)}"
UPINFO="gh-releases-zsync|${GITHUB_REPOSITORY:-radiolamp/mangojuice}|latest|*$ARCH.AppImage.zsync"

LIB4BN="https://raw.githubusercontent.com/VHSgunzo/sharun/refs/heads/main/lib4bin"
URUNTIME="https://github.com/VHSgunzo/uruntime/releases/latest/download/uruntime-appimage-dwarfs-$ARCH"
URUNTIME_LITE="https://github.com/VHSgunzo/uruntime/releases/latest/download/uruntime-appimage-dwarfs-lite-$ARCH"

mkdir -p ./AppDir
cd ./AppDir || exit

if [ -f "/usr/share/applications/io.github.radiolamp.mangojuice.desktop" ]; then
    cp "/usr/share/applications/io.github.radiolamp.mangojuice.desktop" ./
    sed -i 's|^Exec=.*|Exec=mangojuice|' ./io.github.radiolamp.mangojuice.desktop
else
    echo "Ошибка: desktop-файл не найден"
    exit 1
fi

if [ -f "/usr/share/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg" ]; then
    cp "/usr/share/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg" ./
    cp "./io.github.radiolamp.mangojuice.svg" ./.DirIcon
else
    echo "Предупреждение: значёк не найден"
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

echo "Загрузка lib4bin..."
wget --retry-connrefused --tries=30 "$LIB4BN" -O ./lib4bin || {
    echo "Ошибка загрузки lib4bin"
    exit 1
}
chmod +x ./lib4bin

echo "Копирование файлов mangojuice..."
xvfb-run -a -- ./lib4bin -p -v -e -s -k \
    /usr/bin/mangojuice \
    /usr/bin/vkcube \
    /usr/lib/mangohud/* \
    /usr/bin/lspci \
    /usr/bin/gettext \
    /usr/lib/libintl.so* \
    /usr/lib/gdk-pixbuf-*/*/*/* || {
    echo "Ошибка при копировании файлов"
    exit 1
}

mkdir -p ./share/vulkan
if [ -d "/usr/share/vulkan/implicit_layer.d" ]; then
    cp -rv "/usr/share/vulkan/implicit_layer.d" "./share/vulkan/"
    sed -i 's|/usr/lib/mangojuice/||' ./share/vulkan/implicit_layer.d/*
else
    echo "Предупреждение: Vulkan layers не найдены"
fi

# copy anything that remains in ./usr/share to ./share
cp -rv ./usr/share/* ./share || true
rm -rf ./usr/share

cat > ./AppRun << 'EOF'
#!/bin/sh
HERE="$(dirname "$(readlink -f "${0}")")"

# Проверка перевода
echo "Тест перевода: $(gettext -d mangojuice "GPU")" >&2

# Запуск основного приложения
exec "${HERE}/bin/mangojuice" "$@"
EOF
chmod +x ./AppRun
./sharun -g

echo 'MANGOJUICE=1' > ./.env
echo 'TEXTDOMAINDIR="${SHARUN_DIR}/share/locale' >> ./.env
echo 'TEXTDOMAIN="mangojuice' >> ./.env

cd .. || exit
echo "Загрузка uruntime..."
wget --retry-connrefused --tries=30 "$URUNTIME" -O ./uruntime || {
    echo "Ошибка загрузки uruntime"
    exit 1
}
wget --retry-connrefused --tries=30 "$URUNTIME_LITE" -O ./uruntime-lite || {
    echo "Ошибка загрузки uruntime-lite"
    exit 1
}
chmod +x ./uruntime*

echo "Добавление информации об обновлениях..."
./uruntime-lite --appimage-addupdinfo "$UPINFO" || {
    echo "Ошибка добавления информации об обновлении"
    exit 1
}

echo "Создание AppImage..."
./uruntime --appimage-mkdwarfs -f \
    --set-owner 0 --set-group 0 \
    --no-history --no-create-timestamp \
    --compression zstd:level=12 -S26 -B8 \
    --header uruntime-lite \
    -i ./AppDir -o "MangoJuice-${VERSION}-${ARCH}.AppImage" || {
    echo "Ошибка создания AppImage"
    exit 1
}

echo "Готово! Создан AppImage: MangoJuice-${VERSION}-${ARCH}.AppImage"
