project('mangojuice', 'vala',
  version: '0.7.0',
  default_options: ['warning_level=0'])

dependencies = [
  dependency('glib-2.0'),
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('gee-0.8')  
]

# on Relise
add_project_arguments('-Wno-discarded-qualifiers', language: 'c')

sources = files('src/mangojuice.vala')

resources_xml = 'data/resources.gresource.xml'
gnome = import('gnome')
resources_compiled = gnome.compile_resources(
  'mangojuice-resources',
  resources_xml,
  source_dir: 'data',
  gresource_bundle: true
)

executable('mangojuice', sources, resources_compiled, dependencies: dependencies,
  install: true)

install_data(
  'data/assets/icons/io.github.radiolamp.mangojuice-metrics-symbolic.svg',
  'data/assets/icons/io.github.radiolamp.mangojuice-extras-symbolic.svg',
  'data/assets/icons/io.github.radiolamp.mangojuice-performance-symbolic.svg',
  'data/assets/icons/io.github.radiolamp.mangojuice-visual-symbolic.svg',
  'data/icons/hicolor/scalable/apps/io.github.radiolamp.mangojuice.svg',
  install_dir: join_paths(get_option('datadir'), 'icons', 'hicolor', 'scalable', 'apps')
)

desktop_file = 'data/io.github.radiolamp.mangojuice.desktop'
install_data(
  desktop_file,
  install_dir: get_option('datadir') / 'applications'
)