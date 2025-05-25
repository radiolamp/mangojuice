[![En](https://img.shields.io/badge/en-gray)](/README.md) [![Ru](https://img.shields.io/badge/ru-green)](/docs/README-ru.md)

<div align="center">
  <h1>
    <img
      src="data/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg"
      height="64"
    />
    MangoJuice
  </h1>

### Эта программа станет удобной альтернативой GOverlay для настройки MangoHud

<p align="center">
    <img src="data/images/screen1.png" alt="Скриншот"/>
</p>

|             Страница 1              |             Страница 2              |             Страница 3              |             Страница 4              |             Страница 5              |
| :---------------------------------: | :---------------------------------: | :---------------------------------: | :---------------------------------: | :---------------------------------: |
| ![screen1](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen1.png?raw=true) | ![screen2](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen2.png?raw=true) | ![screen3](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen3.png?raw=true) | ![screen4](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen4.png?raw=true) | ![screen5](https://github.com/radiolamp/mangojuice-donate/blob/main/images/screen5.png?raw=true) |

## Установить

**Flathub:**

<a href="https://flathub.org/ru/apps/io.github.radiolamp.mangojuice">
  <img width='240' alt='Download on Flathub' src='https://flathub.org/assets/badges/flathub-badge-ru.svg'/>
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

## Поддержка проекта

Вы можете поддержать проект несколькими способами:

- Создать задачу с проблемой или предложением по улучшению;
- Отправить запрос на слияние с исправлениями или новой функциональностью;
- Оказать финансовую поддержку (укажите ваш ник в сообщении при отправке через Т-Банк).

<br>

<div align="center">
  <a href="https://boosty.to/radiolamp/donate">
    <img height="200" src="data/assets/boosty_qrcode.png" alt="Boosty">
  </a>
  <a href="https://www.donationalerts.com/r/radiolamp">
    <img height="200" src="data/assets/donationalerts_qrcode.png" alt="Donation Alerts">
  </a>
  <a href="https://www.tbank.ru/cf/3PPTstulqEq">
    <img height="200" src="data/assets/tbank_qrcode.png" alt="Т-Банк">
  </a>
</div>

## Благодарность

Благодарю [Rirusha](https://gitlab.gnome.org/Rirusha) за важные разъяснения по Vala и GTK4.

### Проекты, ставшие вдохновлением

- [`MangoHud`](https://github.com/flightlessmango/MangoHud)
- [`Goverlay`](https://github.com/benjamimgois/goverlay)
- [`Colloid`](https://github.com/vinceliuice/Colloid-icon-theme/)

### Обращаю ваше внимание, что это мой первый проект на GTK4 + Vala, прошу отнестись с пониманием.
