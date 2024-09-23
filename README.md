README language: \
[![En](https://img.shields.io/badge/en-green)](README.md)
[![Ru](https://img.shields.io/badge/ru-gray)](docs/RU-README.md)


## MangoJuice
##### This program will be a convenient alternative to Goverlay for setting up Mangohud.

<p align="center">
    <img src="data/images/screen.png" alt="Screenshot"/>
</p>

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

## Support

You can support in several ways:
- Create an issue with a problem or a suggestion for improvement
- Submit a merge request with a fix or new functionality
- Support financially (Please include your nickname in the "Message to the recipient" when sending via T-Bank)

<br>

<div align="center">
  <a href="https://boosty.to/radiolamp/donate"_qrcode
    <img height="200" src="data/assets/boosty_qrcode.png" alt="boosty.to">
  </a>
  <a href="https://www.tbank.ru/cf/1J1DvYNesgD">
  <img height="200" src="data/assets/tbank_qrcodepng" alt="Tinkoff">
  </a>
</div>


## Gratitude
Thank you [Rirusha](https://gitlab.gnome.org/Rirusha). For important clarifications about Vala and GTK4.

### Projects that have become muses.
 - [`Mangohud`](https://github.com/flightlessmango/MangoHud)
 - [`Goverlay`](https://github.com/benjamimgois/goverlay)

### Attention, this is my first project on GTK4 + Vala, so please treat with understanding.