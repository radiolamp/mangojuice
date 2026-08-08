[![En](https://img.shields.io/badge/en-gray)](/README.md) [![Ru](https://img.shields.io/badge/ru-green)](README.ru.md)

<div align="center">
  <h1>
    <img
      src="https://github.com/radiolamp/mangojuice/raw/main/data/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg"
      height="64"
    />
    MangoJuice
  </h1>
</div>

### Эта программа станет удобной альтернативой GOverlay для настройки MangoHud

<p align="center">
    <img src="https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen1.png?raw=true" alt="Скриншот"/>
</p>

| Страница 1 | Страница 2 | Страница 3 | Страница 4 | Страница 5 |
| --- | --- | --- | --- | --- |
| ![screen1](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen1.png?raw=true) | ![screen2](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen2.png?raw=true) | ![screen3](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen3.png?raw=true) | ![screen4](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen4.png?raw=true) | ![screen5](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen0.png?raw=true) |

## Установить

**Flathub:**

<div align="center">
<a href="https://flathub.org/ru/apps/io.github.radiolamp.mangojuice">
  <img width='240' alt='Загрузить с Flathub' src='https://flathub.org/assets/badges/flathub-badge-en.svg'/>
</a>

**AppImage:**

<a href="https://github.com/radiolamp/mangojuice/releases/latest/download/MangoJuice-AppImagename-x86_64.zip">
  <img width='240' alt='Скачать AppImage из релизов GitHub' src='http://docs.appimage.org/_images/download-appimage-banner.svg'/>
</a>
</div>

## Репозитории

[![Статус сборки](https://repology.org/badge/vertical-allrepos/mangojuice.svg)](https://repology.org/project/mangojuice/versions)

Также доступен в репозитории для [`openSUSE`](https://software.opensuse.org/package/mangojuice).

## Сборка исходного кода

### Зависимости

#### Инструменты сборки

- `meson`
- `ninja`
- `cmake`
- `gcc`
- `valac`

#### Требования для сборки

- `gtk4`
- `libadwaita-1`
- `gio-2.0`
- `fontconfig`
- `mangohud`

#### Опциональные зависимости

- `mesa-demos`
- `vulkan-tools`
- `vkbasalt`

### Сборка

```shell
meson setup build
```

### Установка

```shell
sudo ninja -C build install
```

### Удаление

```shell
sudo ninja -C build uninstall
```

## Режим разрабочика

Также в приложении есть режим Devel. Он предназначен для разработки и не рекомендуется использовать его на постоянной основе. В этом режиме тестируются новые возможности версий mangojuice и [mangohud-git](https://aur.archlinux.org/packages/mangohud-git). Если вы все же хотите использовать его, в AUR есть пакет [mangojuice-git]((https://aur.archlinux.org/packages/mangojuice-git)) или вы можете собрать его самостоятельно с помощью следующей команды:

```shell
  meson setup build
  meson configure  build --no-pager -Dis_devel=true
  sudo ninja -C build install
```

## Благодарность

Благодарю [Rirusha](https://gitlab.gnome.org/Rirusha) за важные разъяснения по Vala и GTK4.

### Проекты, ставшие вдохновлением

- [`MangoHud`](https://github.com/flightlessmango/MangoHud)
- [`Goverlay`](https://github.com/benjamimgois/goverlay)
- [`Colloid`](https://github.com/vinceliuice/Colloid-icon-theme/)

### Обращаю ваше внимание, что это мой первый проект на GTK4 + Vala, прошу отнестись с пониманием
