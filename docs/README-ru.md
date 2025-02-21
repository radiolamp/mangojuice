## MangoJuice   [![En](https://img.shields.io/badge/en-gray)](/README.md) [![Ru](https://img.shields.io/badge/ru-green)](/docs/README-ru.md)

### Данная программа стремится стать удобной альтернативой Goverlay, для настройки Mangohud.

<div align="center">
  <img src="/data/images/screen1.png" alt="Preview"/>
</div>

Страница 1 | Страница 2 | Страница 3 | Страница 4| Страница 5
:-:|:-:|:-:|:-:|:-:
![screen](/data/images/screen1.png) | ![screen2](/data/images/screen2.png) | ![screen3](/data/images/screen3.png) | ![screen4](/data/images/screen4.png) | ![screen4](/data/images/screen5.png) 

## Находится в репозиториях:
[![Packaging status](https://repology.org/badge/vertical-allrepos/mangojuice.svg)](https://repology.org/project/mangojuice/versions)

## Сборка из исходного кода

#### Зависимости:
* `gtk4`
* `libadwaita-1`
* `gio-2.0`
* `fontconfig`
* `mangohud`

#### Опциональные Зависимости:
* `mesa-demos`
* `vulkan-tools`
* `vkbasalt`


#### Утилиты для сборки:
* `meson`
* `ninja`
* `cmake`
* `gcc`
* `valac`

### Сборка:

#### Последняя версия
> [!NOTE]
> На данный момент функционал активно дописывается.
```shell
meson setup build
```

### Установка:
```shell
sudo ninja -C build install
```

### Удаление:
```shell
sudo ninja -C build uninstall
```

## Скачать Flatpak:
[`Ночная сборка (Main)`](https://github.com/radiolamp/mangojuice/actions/)

## Установка Flatpak сборки
<strong><span style="color: yellow;">Внимение для полноценной работы установите mangohud из flatpak</span></strong>
```shell
flatpak install --user io.github.radiolamp.mangojuice-x86_64.flatpak
```

## Начальная поддержка Flatpak:
```shell
flatpak-builder --user --install build-dir data/io.github.radiolamp.mangojuice.yml
```
## Горячие клавиши:
- 'Ctrl + Q' - Выйти
- 'Ctrl + S' - Сохранить
- 'Ctrl + E' - Сохранить как
- 'Ctrl + R' - Востановить
- 'Ctrl + T' - Test

## Поддержка

Вы можете оказать поддержку несколькими способами:

- Создайте запрос с проблемой или предложением по улучшению
- Отправьте запрос на слияние с исправлением или новой функциональностью
-Поддержите финансово (Пожалуйста, укажите свой ник в «Сообщении получателю» при отправке через T-Bank)

<br>

<div align="center">
  <a href="https://boosty.to/radiolamp/donate">
    <img height="200" src="/data/assets/boosty_qrcode.png" alt="Boosty">
  </a>
  <a href="https://www.donationalerts.com/r/radiolamp">
  <img height="200" src="/data/assets/donationalerts_qrcode.png" alt="Donationalerts">
  </a>
  <a href="https://www.tbank.ru/cf/1J1DvYNesgD">
    <img height="200" src="/data/assets/tbank_qrcode.png" alt="TBank">
  </a>
</div>

## Благодарность
Thank you [Rirusha](https://gitlab.gnome.org/Rirusha). For important clarifications about Vala and GTK4.

### Ссылки на проекты которыми был вдохновлен.
 - [`Mangohud`](https://github.com/flightlessmango/MangoHud)
 - [`Goverlay`](https://github.com/benjamimgois/goverlay)
 - [`Colloid`](https://github.com/vinceliuice/Colloid-icon-theme/)

### Внимание это мой первый проэкт на GTK4 + Vala, по этому прошу относится с понимаем.