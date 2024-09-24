## MangoJuice   [![En](https://img.shields.io/badge/en-gray)](README.md) [![Ru](https://img.shields.io/badge/ru-green)](docs/README-ru.md)

### Данная программа стремится стать удобной альтернативой Goverlay, для настройки Mangohud.

<p align="center">
    <img src="data/images/screen.png" alt="Screenshot"/>
</p>

## Находится в репозиториях:
[![Packaging status](https://repology.org/badge/vertical-allrepos/mangojuice.svg)](https://repology.org/project/mangojuice/versions)

## Сборка из исходного кода

#### Зависимости:
* `gtk4`
* `libadwaita-1`
* `gio-2.0`
* `mangohud`
* `mesa-demos`
* `vulkan-tools`

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

## Поддержка

Вы можете оказать поддержку несколькими способами:

- Создайте запрос с проблемой или предложением по улучшению
- Отправьте запрос на слияние с исправлением или новой функциональностью
-Поддержите финансово (Пожалуйста, укажите свой ник в «Сообщении получателю» при отправке через T-Bank)

<br>

<div align="center">
  <a href="https://boosty.to/radiolamp/donate">
    <img height="200" src="data/assets/boosty_qrcode.png" alt="Boosty">
  </a>
  <a href="https://www.tbank.ru/cf/1J1DvYNesgD">
    <img height="200" src="data/assets/tbank_qrcode.png" alt="TBank">
  </a>
</div>

## Благодарность
Thank you [Rirusha](https://gitlab.gnome.org/Rirusha). For important clarifications about Vala and GTK4.

### Ссылки на проэкты которыми был вдохновлен.
 - [`Mangohud`](https://github.com/flightlessmango/MangoHud)
 - [`Goverlay`](https://github.com/benjamimgois/goverlay)

### Внимание это мой первый проэкт на GTK4 + Vala, по этому прошу относится с понимаем.