resources = gnome.compile_resources(
    'resources',
    'gresource.xml',
    source_dir: meson.current_build_dir()
)

install_data(
    'icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg',
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)

install_data(
    'io.github.radiolamp.mangojuice.desktop',
    install_dir: get_option('datadir') / 'applications'
)