## Alpha version!

###### Данная программа стремится стать удобной альтернативой Goverlay, для настройки Mangohud.



## Сборка из исходного кода

#### Зависимости:
* `gtk4`, version: `>= 4.14`
* `libadwaita-1`, version: `>= 1.5`
* `gio-2.0`, version: `>= 2.72`
* `mangohud`

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

## Внимание это мой первый проэкт на GTK4 + Vala, по этому прошу относится с понимаем.