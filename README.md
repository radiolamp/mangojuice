## MangoJuice - Alpha version!
##### Данная программа стремится стать удобной альтернативой Goverlay, для настройки Mangohud.

<p align="center">
    <img src="data/images/screen.png" alt="Screenshot"/>
</p>

## Имеется в репозиториях
[![Packaging status](https://repology.org/badge/vertical-allrepos/mangojuice.svg)](https://repology.org/project/mangojuice/versions)

## Сборка из исходного кода

#### Зависимости:
* `gtk4`, version: `>= 4.14`
* `libadwaita-1`, version: `>= 1.5`
* `gio-2.0`, version: `>= 2.72`
* `mangohud`- Hud
* `mesa-demos` - OpenGL preview
* `vulkan-tools` - Vulkan preview

#### Утилиты для сборки:
* `meson`
* `ninja`
* `cmake`
* `gcc`
* `valac`

### Сборка:

#### latest
> [!NOTE]
> На данный момент функционал полностью не реализован.
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

## Благодарность
Спасибо [Rirusha](https://github.com/Rirusha). За важные пояснение за Vala и GTK4.

## Ссылки на проэкты которыми был вдохновлен.
 - [**`Mangohud`**](https://github.com/flightlessmango/MangoHud)
 - [**`Goverlay`**](https://github.com/benjamimgois/goverlay)

## Внимание это мой первый проэкт на GTK4 + Vala, по этому прошу относится с понимаем.