resources = gnome.compile_resources(
    'resources',
    'gresource.xml',
    source_dir: meson.current_build_dir()
)

install_data(
    'assets/icons/io.github.radiolamp.mangojuice-metrics-symbolic.svg',
    'assets/icons/io.github.radiolamp.mangojuice-extras-symbolic.svg',
    'assets/icons/io.github.radiolamp.mangojuice-performance-symbolic.svg',
    'assets/icons/io.github.radiolamp.mangojuice-visual-symbolic.svg',
    'assets/icons/io.github.radiolamp.mangojuice-other-symbolic.svg',
    'icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg',
    install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)

install_data(
    'io.github.radiolamp.mangojuice.desktop',
    install_dir: get_option('datadir') / 'applications'
)