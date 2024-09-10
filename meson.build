project('mangojuice', 'vala',
  version: '0.4.4',
  default_options: ['warning_level=2'])

dependencies = [
  dependency('glib-2.0'),
  dependency('gtk4'),
  dependency('libadwaita-1'),
  dependency('gee-0.8')  
]

sources = files('src/mangojuice.vala')

executable('mangojuice', sources, dependencies: dependencies)