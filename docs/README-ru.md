## MangoJuice [![En](https://img.shields.io/badge/en-gray)](/README.md) [![Ru](https://img.shields.io/badge/ru-green)](/docs/README-ru.md)

### Эта программа станет удобной альтернативой GOverlay для настройки MangoHud

<p align="center">
    <img src="data/images/screen1.png" alt="Скриншот"/>
</p>

|             Страница 1              |             Страница 2              |             Страница 3              |             Страница 4              |             Страница 5              |
| :---------------------------------: | :---------------------------------: | :---------------------------------: | :---------------------------------: | :---------------------------------: |
| ![screen1](data/images/screen1.png) | ![screen2](data/images/screen2.png) | ![screen3](data/images/screen3.png) | ![screen4](data/images/screen4.png) | ![screen5](data/images/screen5.png) |

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

## Flatpak

```shell
flatpak install --user https://dl.flathub.org/build-repo/181356/io.github.radiolamp.mangojuice.flatpakref
```

### Скачать Flatpak

[`Сборка Nightly (Основная)`](https://github.com/radiolamp/mangojuice/actions/)

### Установить сборку Flatpak

> [ВНИМАНИЕ] Обратите внимание: для полной функциональности установите MangoHud через Flatpak</span></strong>

```shell
flatpak install --user io.github.radiolamp.mangojuice-x86_64.flatpak
```


## Горячие клавиши

| Горячая клавиша  |   Описание    |
| :--------------: | :-----------: |
| [[Ctrl]] + [[Q]] |     Выход     |
| [[Ctrl]] + [[S]] |   Сохранить   |
| [[Ctrl]] + [[E]] | Сохранить как |
| [[Ctrl]] + [[R]] | Восстановить  |
| [[Ctrl]] + [[T]] | Тестирование  |

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
