project('mangojuice', 'vala',
  version: '0.6.0',
  default_options: ['warning_level=0'])

# Зависимости
dependencies = [
  dependency('glib-2.0'),
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('gee-0.8')  
]

# Исходные файлы
sources = files('src/mangojuice.vala')

# Ресурсы
resources_xml = 'data/resources.gresource.xml'
gnome = import('gnome')
resources_compiled = gnome.compile_resources(
  'mangojuice-resources',
  resources_xml,
  source_dir: 'data',
  gresource_bundle: true
)

# Сборка исполняемого файла
executable('mangojuice', sources, resources_compiled, dependencies: dependencies,
  install: true)

# Установка значка
install_data(
  'data/assets/icons/io.github.radiolamp.mangojuice-metrics.svg',
  'data/assets/icons/io.github.radiolamp.mangojuice-extras.svg',
  'data/assets/icons/io.github.radiolamp.mangojuice-performance.svg',
  'data/assets/icons/io.github.radiolamp.mangojuice-visual.svg',
  'data/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg',
  install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)

# Установка .desktop файла
desktop_file = 'data/io.github.radiolamp.mangojuice.desktop'
install_data(
  desktop_file,
  install_dir: get_option('datadir') / 'applications'
)