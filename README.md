
## MangoJuice   [![En](https://img.shields.io/badge/en-green)](README.md) [![Ru](https://img.shields.io/badge/ru-gray)](docs/README-ru.md)

### This program will be a convenient alternative to Goverlay for setting up Mangohud.

<p align="center">
    <img src="data/images/screen.png" alt="Screenshot"/>
</p>


Page 1 | Page 2 | Page 3 | Page 4
:-:|:-:|:-:|:-:
![screen](data/images/screen.png) | ![screen2](data/images/screen2.png) | ![screen3](data/images/screen3.png) | ![screen4](data/images/screen4.png) 

## Repositories:
[![Packaging status](https://repology.org/badge/vertical-allrepos/mangojuice.svg)](https://repology.org/project/mangojuice/versions)

## Building the source code

#### Dependencies:
* `gtk4`
* `libadwaita-1`
* `gio-2.0`
* `mangohud`
* `mesa-demos`
* `vulkan-tools`

#### Build utilities:
* `meson`
* `ninja`
* `cmake`
* `gcc`
* `valac`

### Building:

#### latest
> [!NOTE]
> The functionality is currently being improved.
```shell
meson setup build
```

### Install:
```shell
sudo ninja -C build install
```

### Uninstall:
```shell
sudo ninja -C build uninstall
```

## Support:

You can support in several ways:
- Create an issue with a problem or a suggestion for improvement
- Submit a merge request with a fix or new functionality
- Support financially (Please include your nickname in the "Message to the recipient" when sending via T-Bank)

<br>

<div align="center">
  <a href="https://boosty.to/radiolamp/donate">
    <img height="200" src="data/assets/boosty_qrcode.png" alt="Boosty">
  </a>
  <a href="https://www.tbank.ru/cf/1J1DvYNesgD">
    <img height="200" src="data/assets/tbank_qrcode.png" alt="TBank">
  </a>
</div>


## Gratitude:
Thank you [Rirusha](https://gitlab.gnome.org/Rirusha). For important clarifications about Vala and GTK4.

### Projects that have become muses:
 - [`Mangohud`](https://github.com/flightlessmango/MangoHud)
 - [`Goverlay`](https://github.com/benjamimgois/goverlay)
 - [`Colloid`](https://github.com/vinceliuice/Colloid-icon-theme/) 

### Attention, this is my first project on GTK4 + Vala, so please treat with understanding.
